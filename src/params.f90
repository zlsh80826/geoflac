! -*- F90 -*-
module params
implicit none

integer, parameter :: maxzone = 10   ! max nzonx and nzony
integer, parameter :: maxtrzone = 20   ! max nzone_marker and nzone_tracer
integer, parameter :: maxphasel = 20   ! max nphasl
integer, parameter :: maxbc = 20   ! max # of bcs
integer, parameter :: maxzone_age = 32   ! max # of nzone_age
integer, parameter :: maxph = 20   ! max # of phases
integer, parameter :: maxinh = 50   ! max # of inhomogeneities

real*8, parameter :: sec_year = 3.1558d+7  ! seconds in a year


integer :: nx,nz,nzonx,nzony,nelz_x(maxzone),nelz_y(maxzone), &
     ny_rem,mode_rem,ntest_rem,ivis_shape,igeotherm, &
     ny_inject,nelem_inject,nmass_update,nopbmax,nydrsides,nystressbc, &
     nofbc,nofside(maxbc),nbc1(maxbc),nbc2(maxbc),nbc(maxbc), &
     mix_strain,mix_stress,lastsave,lastout, &
     io_vel,io_srII,io_eII,io_aps,io_sII,io_sxx,io_szz, &
     io_sxz,io_pres,io_temp,io_phase,io_visc,io_unused,io_density, &
     io_src,io_diss,io_forc,io_hfl,io_topo, &
     irphase,irtemp,ircoord, &
     nphase,mphase,irheol(maxph), &
     ltop(maxphasel),lbottom(maxphasel),lphase(maxphasel), &
     imx1(maxtrzone),imx2(maxtrzone),imy1(maxtrzone),imy2(maxtrzone), &
     itx1(maxtrzone),itx2(maxtrzone),ity1(maxtrzone),ity2(maxtrzone), &
     nphasl,nzone_marker,nmarkers, iint_marker,iint_tracer,nzone_tracer, &
     ix1(maxinh),ix2(maxinh),iy1(maxinh),iy2(maxinh),inphase(maxinh), &
     igeom(maxinh),inhom, &
     itherm,istress_therm,itemp_bc,ix1t,ix2t,iy1t,iy2t,ishearh, &
     ixtb1(maxzone_age),ixtb2(maxzone_age),nzone_age,i_prestress, &
     iph_col1(maxzone_age),iph_col2(maxzone_age),iph_col3(maxzone_age), &
     iph_col4(maxzone_age),iph_col5(maxzone_age),iph_col_trans(maxzone_age), &
     if_hydro, &
     nyhydro,iphsub, &
     movegrid,ndim,ifreq_visc,nmtracers,i_rey, &
     incoming_left,incoming_right, &
     iynts, iax1,iay1,ibx1,iby1,icx1,icy1,idx1,idy1, &
     ivis_present,n_boff_cutoff,idt_scale,ifreq_imasses,ifreq_rmasses, &
     nloop,ifreq_avgsr,nsrate

real*8 :: x0,z0,rxbo,rzbo,sizez_x(maxzone),sizez_y(maxzone), &
     dx_rem,angle_rem,topo_kappa,fac_kappa, &
     v_min,v_max,efoldc, &
     g_x0,g_y0c,g_amplitude,g_width, &
     rate_inject, &
     bca(maxbc),bcb(maxbc),bcc(maxbc),xReyn, &
     bcd(maxbc),bce(maxbc),bcf(maxbc),bcg(maxbc),bch(maxbc),bci(maxbc), &
     dt_scale,strain_inert,vbc,amul,ratl,ratu,frac, &
     dtmax_therm,dt_maxwell,fracm, &
     dt_elastic,demf, &
     dtout_screen,dtout_file,dtsave_file, &
     visc(maxph),den(maxph),alfa(maxph),beta(maxph),pln(maxph), &
     acoef(maxph),eactiv(maxph),rl(maxph),rm(maxph), &
     plstrain1(maxph),plstrain2(maxph),fric1(maxph),fric2(maxph), &
     cohesion1(maxph),cohesion2(maxph), &
     dilat1(maxph),dilat2(maxph), &
     conduct(maxph),cp(maxph), &
     ts(maxph),tl(maxph),tk(maxph),fk(maxph), &
     ten_off,tau_heal,dt_outtracer,xinitaps(maxinh), &
     t_top,t_bot,hs,hr,temp_per,bot_bc, &
     hc1(maxzone_age),hc2(maxzone_age),hc3(maxzone_age),hc4(maxzone_age), &
     age_1(maxzone_age),g,pisos,drosub,damp_vis, &
     dtavg, tbos, &
     time,dt,time_max

character phasefile*20,tempfile*20,coordfile*20

end module params
