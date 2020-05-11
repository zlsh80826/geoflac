subroutine init_tracer
USE marker_data
use arrays
use params
implicit none

integer, allocatable :: ielem(:,:)
integer :: i, j, k, kk, n, nn

allocate(ielem(nz, nx))
ielem = 0
nmtracers = 0
!$ACC update device(nmtracers)

do kk = 1,nmarkers
    n = mark_ntriag(kk)
    nn = (n-1)/2
    k = mod(n-1, 2) + 1
    j = mod(nn, nz-1) + 1
    i = nn/(nz-1) + 1

    if(ielem(j,i) == 0) then
        do n = 1, nzone_tracer
            if(i >= itx1(n) .and. i <= itx2(n) .and. &
                 j >= ity1(n) .and. j <= ity2(n)) then
                ielem(j,i) = 1
                nmtracers = nmtracers + 1
                !$ACC update device(nmtracers)
                ! Storing the array index of this marker, assuming that
                ! markers never move in the array
                idtracer(nmtracers) = kk
            endif
        enddo
    endif
enddo
deallocate(ielem)
return
end subroutine init_tracer
