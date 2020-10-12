
! Setup some parameters (rmass,amass,initial stress,vel,viscosity)

subroutine setflac
use arrays
use params
use nvtx_mod
include 'precision.inc'


nloop = 0
time = 0.d0
!$ACC update device(nloop,time)

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

!$ACC update device(nx,nz,nzonx,nzony,nelz_x(maxzone),nelz_y(maxzone), &
!$ACC     ny_rem,mode_rem,ntest_rem,ivis_shape,igeotherm, &
!$ACC     ny_inject,nelem_inject,nmass_update,nopbmax,nydrsides,nystressbc, &
!$ACC     nofbc,nofside(maxbc),nbc1(maxbc),nbc2(maxbc),nbc(maxbc), &
!$ACC     mix_strain,mix_stress,lastsave,lastout, &
!$ACC     io_vel,io_srII,io_eII,io_aps,io_sII,io_sxx,io_szz, &
!$ACC     io_sxz,io_pres,io_temp,io_phase,io_visc,io_unused,io_density, &
!$ACC     io_src,io_diss,io_forc,io_hfl,io_topo, &
!$ACC     irphase,irtemp,ircoord, &
!$ACC     nphase,mphase,irheol(maxph), &
!$ACC     ltop(maxphasel),lbottom(maxphasel),lphase(maxphasel), &
!$ACC     imx1(maxtrzone),imx2(maxtrzone),imy1(maxtrzone),imy2(maxtrzone), &
!$ACC     itx1(maxtrzone),itx2(maxtrzone),ity1(maxtrzone),ity2(maxtrzone), &
!$ACC     nphasl,nzone_marker,nmarkers, iint_marker,iint_tracer,nzone_tracer, &
!$ACC     ix1(maxinh),ix2(maxinh),iy1(maxinh),iy2(maxinh),inphase(maxinh), &
!$ACC     igeom(maxinh),inhom, &
!$ACC     itherm,istress_therm,itemp_bc,ix1t,ix2t,iy1t,iy2t,ishearh, &
!$ACC     ixtb1(maxzone_age),ixtb2(maxzone_age),nzone_age,i_prestress, &
!$ACC     iph_col1(maxzone_age),iph_col2(maxzone_age),iph_col3(maxzone_age), &
!$ACC     iph_col4(maxzone_age),iph_col5(maxzone_age),iph_col_trans(maxzone_age), &
!$ACC     if_hydro, &
!$ACC     nyhydro,iphsub, &
!$ACC     movegrid,ndim,ifreq_visc,nmtracers,i_rey, &
!$ACC     incoming_left,incoming_right, &
!$ACC     iynts, iax1,iay1,ibx1,iby1,icx1,icy1,idx1,idy1, &
!$ACC     ivis_present,n_boff_cutoff,idt_scale,ifreq_imasses,ifreq_rmasses, &
!$ACC     nloop,ifreq_avgsr)

!$ACC update device(x0,z0,rxbo,rzbo,sizez_x(maxzone),sizez_y(maxzone), &
!$ACC     dx_rem,angle_rem,topo_kappa,fac_kappa, &
!$ACC     v_min,v_max,efoldc, &
!$ACC     g_x0,g_y0c,g_amplitude,g_width, &
!$ACC     rate_inject, &
!$ACC     bca(maxbc),bcb(maxbc),bcc(maxbc),xReyn, &
!$ACC     bcd(maxbc),bce(maxbc),bcf(maxbc),bcg(maxbc),bch(maxbc),bci(maxbc), &
!$ACC     dt_scale,strain_inert,vbc,amul,ratl,ratu,frac, &
!$ACC     dt_maxwell,fracm, &
!$ACC     dt_elastic,demf, &
!$ACC     dtout_screen,dtout_file,dtsave_file, &
!$ACC     visc(maxph),den(maxph),alfa(maxph),beta(maxph),pln(maxph), &
!$ACC     acoef(maxph),eactiv(maxph),rl(maxph),rm(maxph), &
!$ACC     plstrain1(maxph),plstrain2(maxph),fric1(maxph),fric2(maxph), &
!$ACC     cohesion1(maxph),cohesion2(maxph), &
!$ACC     dilat1(maxph),dilat2(maxph), &
!$ACC     conduct(maxph),cp(maxph), &
!$ACC     ts(maxph),tl(maxph),tk(maxph),fk(maxph), &
!$ACC     ten_off,tau_heal,dt_outtracer,xinitaps(maxinh), &
!$ACC     t_top,t_bot,hs,hr,temp_per,bot_bc, &
!$ACC     hc1(maxzone_age),hc2(maxzone_age),hc3(maxzone_age),hc4(maxzone_age), &
!$ACC     age_1(maxzone_age),g,pisos,drosub,damp_vis, &
!$ACC     dtavg, tbos, &
!$ACC     time,dt,time_max)

! Distribution of REAL masses to nodes
call nvtxStartRange('rmasses')
call rmasses
call nvtxEndRange()

! Initialization of viscosity
call nvtxStartRange('init_visc')
if( ivis_present.eq.1 ) call init_visc
call nvtxEndRange()

! Inertial masses and time steps (elastic and maxwell)
call nvtxStartRange('dt_mass')
call dt_mass
call nvtxEndRange()

! Initiate parameters for stress averaging
dtavg=0
nsrate=-1

return
end
