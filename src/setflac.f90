
! Setup some parameters (rmass,amass,initial stress,vel,viscosity)

subroutine setflac
use arrays
use params
include 'precision.inc'


nloop = 0
time = 0.d0

! Mesh generator
call init_cord

! Initial accumulated plastic strain
aps = 0

! Initial velocity
vel = 0

dvol = 0
strain = 0

! Phases in the mesh
call init_phase

! Setup markers
if (iint_marker.eq.1) then
    call init_marker
    ! Setup tracers
    if (iint_tracer.eq.1) call init_tracer
endif

! Inverse Areas of triangles
call init_areas

! Initiate temperature field
call init_temp

! Calculation of the initial STRESSES (as hydrostatic)
call init_stress

! Setup boundary conditions
call init_bc

temp0 = temp
shrheat = 0
sshrheat = 0
dtopo = 0
extrusion = 0
andesitic_melt_vol = 0
e2sr = 1d-16
se2sr = 1d-16

! Distribution of REAL masses to nodes
call rmasses

! Initialization of viscosity
if( ivis_present.eq.1 ) call init_visc

! Inertial masses and time steps (elastic and maxwell)
call dt_mass

! Initiate parameters for stress averaging
dtavg=0
nsrate=-1

return
end
