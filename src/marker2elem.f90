subroutine marker2elem
  !$ACC routine gang
  use myrandom_mod
  use marker_data
  use arrays
  use params
  implicit none

  integer :: kph(1), i, j, k, kinc, inc, iseed
  double precision :: x1, x2, y1, y2, xx, yy, r1, r2

  !character*200 msg

  ! Interpolate marker properties into elements
  ! Find the triangle in which each marker belongs

  iseed = 0
  !$OMP parallel do private(kinc,r1,r2,x1,y1,x2,y2,xx,yy,inc)
  !$ACC loop gang vector collapse(2)
  do i = 1 , nx-1
      do j = 1 , nz-1
          kinc = nmark_elem(j,i)

          !  if there are too few markers in the element, create a new one
          !  with age 0 (similar to initial marker)
          !if(kinc.le.4) then
          !    write(msg,*) 'marker2elem: , create a new marker in the element (i,j))', i, j
          !    call SysMsg(msg)
          !endif
          do while (kinc.le.4)
              call myrandom(iseed, r1)
              call myrandom(iseed, r2)

              ! (x1, y1) and (x2, y2)
              x1 = cord(j  ,i,1)*(1-r1) + cord(j  ,i+1,1)*r1
              y1 = cord(j  ,i,2)*(1-r1) + cord(j  ,i+1,2)*r1
              x2 = cord(j+1,i,1)*(1-r1) + cord(j+1,i+1,1)*r1
              y2 = cord(j+1,i,2)*(1-r1) + cord(j+1,i+1,2)*r1

              ! connect
              ! (this point is not uniformly distributed within the element area
              ! and is biased against the thicker side of the element, but this
              ! point is almost gauranteed to be inside the element)
              xx = x1*(1-r2) + x2*r2
              yy = y1*(1-r2) + y2*r2

              call add_marker(xx, yy, iphase(j,i), 0.d0, j, i, inc)
              if(inc.le.0) cycle

              kinc = kinc + 1
          enddo

          call count_phase_ratio(j,i)

      enddo
  enddo
  !$OMP end parallel do

  return
end subroutine marker2elem
