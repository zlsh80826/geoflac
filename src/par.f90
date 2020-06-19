! -*- F90 -*-

program DREZINA
use arrays
use params
use marker_data
implicit none

character*200 inputfile
real*4 secnds,time0
integer :: narg, iargc, j, itest_mesh
double precision :: dtacc_file, dtacc_save, dtacc_screen, dtacc_tracer

narg = iargc()
if(narg /= 1) then
    write(*,*) 'usage: flac inputfile'
    stop 1
endif
call getarg(1, inputfile)

open( 333, file='output.asc' )

time0 = secnds(0.0)

nloop = 0
nloop_restarted = 0
!$ACC update device(nloop,nloop_restarted)

! Read task parameters
call read_params(inputfile)
call allocate_arrays(nz, nx)
call allocate_markers(nz, nx)

! Try to read save-file contents. If file exist - restart, othewise - new start
open(1,file='_contents.rs',status='old',err=10)

irestart = 1
!$ACC update device(irestart)
close(1)
goto 20

10 irestart = 0
!$ACC update device(irestart)

20 continue

if ( irestart .eq. 1 ) then  !file exists - restart
    call rsflac
    nloop_restarted = nloop + 1
    !$ACC update device(nloop_restarted)
    if( dtout_screen .ne. 0 ) then
        write(6,*) 'you CONTINUE from  ', nloop_restarted, ' step'
    else
        call SysMsg('you CONTINUE the execution')
    endif
else ! file does not exist - new start
    if( dtout_screen .ne. 0 ) then
        write(6,*) 'you have NEW start conditions'
        write(333,*) 'you have NEW start conditions'
    else
        call SysMsg('you have NEW start conditions')
    endif
    call setflac
    ! Output of initial configuration
    call outflac
    if (iint_marker.eq.1) call outmarker
end if


!      ****************** running ********************************
dtacc_screen = 0
dtacc_file = 0
dtacc_save = 0
dtacc_tracer = 0

!do index_nobody_would_use=1,1
do while( time .le. time_max )
  if( dtout_screen .ne. 0 ) then
    if( dtacc_screen .gt. dtout_screen ) then
       write(*,'(I10,A,F7.3,A,F8.1,A)') nloop,'''s step. Time[My]=', time/sec_year/1.d+6, &
                ',  elapsed sec-', secnds(time0)
       write(333,'(I10,A,F7.3,A,F8.1,A)') nloop,'''s step. Time[My]=', time/sec_year/1.d+6, &
                ',  elapsed sec-', secnds(time0)
       dtacc_screen = 0
    endif
  endif

  ! ! Forces at the boundaries
  ! if( io_forc==1 .and. mod(nloop, 1000)==0) then
  !     force_l=0.d0
  !     force_r=0.d0
  !     do j = 1,nz-1
  !         sxx = 0.25d0 * (stress0(j,1,1,1)+stress0(j,1,1,2)+stress0(j,1,1,3)+stress0(j,1,1,4) )
  !         sxxd = sxx-stressI(j,1)
  !         dl = cord(j+1,1,2)-cord(j,1,2)
  !         force_l = force_l + sxxd*dl
  !
  !         sxx = 0.25d0 * (stress0(j,nx-1,1,1)+stress0(j,nx-1,1,2)+stress0(j,nx-1,1,3)+stress0(j,nx-1,1,4) )
  !         sxxd = sxx-stressI(j,nx-1)
  !         dl = cord(j+1,nx-1,2)-cord(j,nx-1,2)
  !         force_r = force_r + sxxd*dl
  !     end do
  !     open (1,file='forc.0',position='append')
  !     write (1,'(i10,1x,f7.3,1x,e10.3,1x,e10.3)') nloop, time/sec_year/1.d6, force_l, force_r
  !     close (1)
  ! endif

  do j = 1, ntest_rem
    ! FLAC
    call flac

    nloop = nloop + 1
    time = time + dt
    !$ACC update device(nloop,time)

    dtacc_screen = dtacc_screen + dt
    dtacc_file   = dtacc_file   + dt
    dtacc_save   = dtacc_save   + dt
    dtacc_tracer = dtacc_tracer + dt
  end do

  ! Remeshing
  if( ny_rem.eq.1 .and. itherm.ne.2 ) then
    if( itest_mesh() .eq. 1 ) then
      if(iynts.eq.1) call init_temp

      ! If there are markers recalculate their x,y global coordinate and assign them aps, eII, press, temp
      if(iint_marker.eq.1) then
        call bar2euler
      endif
      call remesh
      ! If markers are present recalculate a1,a2 local coordinates and assign elements with phase ratio vector
      if (iint_marker.eq.1) then
        call lpeuler2bar
        call marker2elem
      endif
    endif
  endif

    ! OUTPUT  
  if( dtout_file .ne. 0 ) then 
    if( dtacc_file .gt. dtout_file ) then
      call outflac
      if (iint_marker.eq.1) call outmarker
      dtacc_file = 0
    endif
  endif
  if ( iint_tracer.eq.1) then
    if (dtacc_tracer.gt.dt_outtracer) then
      call outtracer
      dtacc_tracer = 0
    endif
  endif
  ! SAVING the restart information
  if( dtsave_file .ne. 0 ) then 
    if( dtacc_save .gt. dtsave_file ) then
      call saveflac
      dtacc_save = 0
    endif
  endif

end do

! SAVING the restart information of last step
call saveflac

close(333)

call SysMsg('Congratulations !')
end program DREZINA
