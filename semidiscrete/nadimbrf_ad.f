c                           disclaimer
c
c   this file was generated by taf version 1.9.69
c
c   fastopt disclaims  all  warranties,  eprior_xess  or  implied,
c   including (without limitation) all implied  warranties  of
c   merchantability  or fitness for a particular purpose, with
c   respect to the software and user programs.   in  no  event
c   shall  fastopt be liable for any lost or anticipated prof-
c   its, or any indirect, incidental, exemplary,  special,  or
c   consequential  damages, whether or not fastopt was advised
c   of the possibility of such damages.
c
c                           haftungsbeschraenkung
c   fastopt gibt ausdruecklich keine gewaehr, explizit oder indirekt,
c   bezueglich der brauchbarkeit  der software  fuer einen bestimmten
c   zweck.   unter  keinen  umstaenden   ist  fastopt   haftbar  fuer
c   irgendeinen verlust oder nicht eintretenden erwarteten gewinn und
c   allen indirekten,  zufaelligen,  exemplarischen  oder  speziellen
c   schaeden  oder  folgeschaeden  unabhaengig  von einer eventuellen
c   mitteilung darueber an fastopt.
c
      subroutine nadimbrf_ad( ipt,theta_i, phi_i, nv, 
     $theta_v, phi_v,
     $ lad, xrs, xrs_ad, xhc, xhc_ad, xlai, xlai_ad, rpl, rpl_ad, xrl,
     $ xrl_ad, xtl, xtl_ad, brf_ad) 
c******************************************************************
c******************************************************************
c** this routine was generated by automatic differentiation.     **
c** fastopt: transformation of algorithm in fortran, taf 1.9.69  **
c******************************************************************
c******************************************************************
c==============================================
c all entries are defined explicitly
c==============================================
      use  mo_nad
      use dataSpec_p5
      implicit none

c==============================================
c declare arguments
c==============================================
      integer :: nv,ipt
      double precision :: brf_ad(nv,nw)
      integer :: lad
      double precision :: phi_i
      double precision :: phi_v(nv)
      double precision :: rpl
      double precision :: rpl_ad(nw)
      double precision :: theta_i
      double precision :: theta_v(nv)
      double precision :: xhc
      double precision :: xhc_ad(nw)
      double precision :: xlai
      double precision :: xlai_ad(nw)
      double precision :: xrl(nw)
      double precision :: xrl_ad(nw)
      double precision :: xrs(nw)
      double precision :: xrs_ad(nw)
      double precision :: xtl(nw)
      double precision :: xtl_ad(nw)

c==============================================
c declare local variables
c==============================================
      double precision :: help_h
      double precision :: help_i(nw)
      double precision :: help_j(nw)
      integer :: i
      integer :: na
      double precision :: phi(nv)
      double precision :: r1_ad(nw)
      double precision :: r2_ad(nw)
      double precision :: r3_ad(nw)
      double precision :: teta(nv)
      double precision :: x_lambda_i(nw)
      double precision :: xmeas_ad(nw)
      double precision :: tmplai_ad(nw)
      double precision :: tmplai(nw)
c      print*, 'xx1',ipt,theta_i, phi_i, nv,nw
c      print*,'xx2',theta_v, phi_v
c      print*, 'xx3',lad, xrs, xrs_ad, xhc, xhc_ad, xlai, xlai_ad 
c      print*,'xx4',rpl, rpl_ad, xrl
c      print*, 'xx5',xrl_ad, xtl, xtl_ad, brf_ad
c      brf_ad=1
c initialise local variables
      help_h = 0
      help_i = 0
      help_j = 0
      na = 0
      phi = 0
      teta=0
      x_lambda_i=0
      tmplai_ad=0
c----------------------------------------------
c reset local adjoint variables
c----------------------------------------------
      r1_ad = 0.
      r2_ad = 0.
      r3_ad = 0.
      xmeas_ad = 0.
c----------------------------------------------
c routine body
c----------------------------------------------
      lai(1:nw) = xlai
      h_c(1:nw) = xhc
      df(1:nw) = rpl*2.
      ild = lad
      rl(1:nw) = xrl
      tl(1:nw) = xtl
      rs(1:nw) = xrs
      na = nv
      teta_0 = (180.-theta_i)*pi/180.
      phi_0 = phi_i*pi/180.
      do i = 1, na
        teta(i) = theta_v(i)*pi/180.
        phi(i) = phi_v(i)*pi/180.
      end do
      number = 16
      help_h = -1.
      call gauleg( help_h,1.,points,weights,number )
      call bunnik( ild )
      tmplai = lai(1:nw)
      call archi( tmplai,teta_0 )
      lai(1:nw) = tmplai
      call multiple_dom(teta_0 )
      do i = na, 1, -1

        call g_ross(help_i,teta_0)
        call g_ross(help_j,teta(i))
        x_lambda_i = 0.01*abs(cos(teta_0))/help_i*abs(cos(teta(i)))/
     $help_j

        if(lai(1)/x_lambda_i(1) > 100) then
          x_lambda_i(1) = lai(1)/100
        endif
        xmeas_ad = xmeas_ad+brf_ad(i,1:nw)
        brf_ad(i,:) = 0.

        r1_ad = r1_ad+xmeas_ad
        r2_ad = r2_ad+xmeas_ad
        r3_ad = r3_ad+xmeas_ad
        xmeas_ad = 0.

        call rho_mult_nadh_ad( r3_ad,teta(i) )
        r3_ad = 0.

        call rho_1_nadh_ad( r2_ad,teta(i),phi(i),x_lambda_i )
        r2_ad = 0.
        call rho_0_nadh_ad( r1_ad,teta(i),phi(i),x_lambda_i )
        r1_ad = 0.
      end do
      call multiple_dom_ad( ipt,teta_0 )
      tmplai_ad = lai_ad(1:nw)
      tmplai = lai(1:nw)
      call archi_ad( tmplai,tmplai_ad,teta_0 )
      lai_ad(1:nw) = tmplai_ad
      lai(1:nw) = tmplai
      xrs_ad(1:nw) = xrs_ad(1:nw)+rs_ad(1:nw)
      rs_ad = 0.
      xtl_ad(1:nw) = xtl_ad(1:nw)+tl_ad(1:nw)
      tl_ad = 0.
      xrl_ad(1:nw) = xrl_ad(1:nw)+rl_ad(1:nw)
      rl_ad = 0.
      rpl_ad(1:nw) = rpl_ad(1:nw)+2*df_ad(1:nw)
      df_ad = 0.
      xhc_ad(1:nw) = xhc_ad(1:nw)+h_c_ad(1:nw)
      h_c_ad = 0.
      xlai_ad(1:nw) = xlai_ad(1:nw)+tmplai_ad
c      print*,'xxhere',xlai_ad,lai_ad
      lai_ad =  0.
      end subroutine nadimbrf_ad


      subroutine nadimbrfmd( ipt,theta_i, phi_i, 
     $nv, theta_v, phi_v, lad, 
     $xrs, xhc, xlai, rpl, xrl, xtl, brf )
c******************************************************************
c******************************************************************
c** this routine was generated by automatic differentiation.     **
c** fastopt: transformation of algorithm in fortran, taf 1.9.69  **
c******************************************************************
c******************************************************************
c==============================================
c all entries are defined explicitly
c==============================================
      use mo_nad
      implicit none
      integer ipt
c==============================================
c declare arguments
c==============================================
      integer :: nv
      double precision :: brf(nv,nw)
      integer :: lad
      double precision :: phi_i
      double precision :: phi_v(nv)
      double precision :: rpl
      double precision :: theta_i
      double precision :: theta_v(nv)
      double precision :: xhc
      double precision :: xlai
      double precision :: xrl(nw)
      double precision :: xrs(nw)
      double precision :: xtl(nw)

c==============================================
c declare local variables
c==============================================
      double precision :: help_h
      double precision :: help_i(nw)
      double precision :: help_j(nw)
      integer :: i
      integer :: na
      double precision :: phi(nv)
      double precision :: r1(nw)
      double precision :: r2(nw)
      double precision :: r3(nw)
      double precision :: teta(nv)
      double precision :: x_lambda_i(nw)
      double precision :: xmeas
      double precision :: tmplai(nw)
c initialise locals
      help_h=0
      help_i=0
      help_j=0
      na=0
      phi=0
      r1=0
      r2=0
      r3=0
      teta=0
      x_lambda_i=0
      xmeas=0
c**********************************************
c executable statements of routine
c**********************************************
      lai(1:nw) = xlai
      h_c(1:nw) = xhc
      df(1:nw) = rpl*2.
      ild = lad
      rl(1:nw) = xrl
      tl(1:nw) = xtl
      rs(1:nw) = xrs
      na = nv
      teta_0 = (180.-theta_i)*pi/180.
      phi_0 = phi_i*pi/180.
      do i = 1, na
        teta(i) = theta_v(i)*pi/180.
        phi(i) = phi_v(i)*pi/180.
      end do
      number = 16
      help_h = -1.
      call gauleg( help_h,1.,points,weights,number )
      call bunnik( ild )
      tmplai = lai(1:nw)
      call archi( tmplai,teta_0 )
      lai(1:nw) = tmplai
      call multiple_dommd(ipt, teta_0 )
      do i = 1, na
        call g_ross(help_i,teta_0)
        call  g_ross(help_j,teta(i))
        x_lambda_i = 0.01*abs(cos(teta_0))/help_i*abs(cos(teta(i)))/
     $help_j
        call rho_0_nad(r1,teta(i),phi(i),x_lambda_i)
        call rho_1_nad(r2,teta(i),phi(i),x_lambda_i)
        call rho_mult_nad(r3,teta(i))
        brf(i,:)= r3+r1+r2
      end do
      end subroutine nadimbrfmd


      subroutine nadimbrf( theta_i, phi_i, nv, theta_v, 
     $ phi_v, lad, xrs,
     $ xhc, xlai, rpl, xrl, xtl, brf )
c******************************************************************
c******************************************************************
c** this routine was generated by automatic differentiation.     **
c** fastopt: transformation of algorithm in fortran, taf 1.9.69  **
c******************************************************************
c******************************************************************
c==============================================
c all entries are defined explicitly
c==============================================
      use mo_nad
      use dataspec_p5
      implicit none
c==============================================
c declare arguments
c==============================================
      integer :: nv
      double precision :: brf(nv,nw)
      integer :: lad
      double precision :: phi_i
      double precision :: phi_v(nv)
      double precision :: rpl
      double precision :: theta_i
      double precision :: theta_v(nv)
      double precision :: xhc
      double precision :: xlai
      double precision :: xrl(nw)
      double precision :: xrs(nw)
      double precision :: xtl(nw)

c==============================================
c declare local variables
c==============================================
      double precision :: help_h
      double precision :: help_i(nw)
      double precision :: help_j(nw)
      integer :: i
      integer :: na
      double precision :: phi(nv)
      double precision :: r1(nw)
      double precision :: r2(nw)
      double precision :: r3(nw)
      double precision :: teta(nv)
      double precision :: x_lambda_i(nw)
      double precision :: tmplai(nw)
c      double precision :: xmeas
c initialise locals
      help_h=0
      help_i=0
      help_j=0
      na=0
      phi=0
      r1=0
      r2=0
      r3=0
      teta=0
      x_lambda_i=0
c start code
      lai(1:nw) = xlai
      h_c(1:nw) = xhc
      df(1:nw) = rpl*2.
      ild = lad
      rl(1:nw) = xrl
      tl(1:nw) = xtl
      rs(1:nw) = xrs
      na = nv
      teta_0 = (180.-theta_i)*pi/180.
      phi_0 = phi_i*pi/180.
      do i = 1, na
        teta(i) = theta_v(i)*pi/180.
        phi(i) = phi_v(i)*pi/180.
      end do
      number = 16
      help_h = -1.
      call gauleg( help_h,1.,points,weights,number )
      call bunnik( ild )
      tmplai = lai(1:nw)
      call archi( tmplai,teta_0 )
      lai(1:nw) = tmplai
      call multiple_dom( teta_0 )
      do i = 1, na
        call g_ross(help_i,teta_0)
        call g_ross(help_j,teta(i))
        x_lambda_i = 0.01*abs(cos(teta_0))/help_i*abs(cos(teta(i)))/
     $help_j
        call rho_0_nad(r1,teta(i),phi(i),x_lambda_i)
        call rho_1_nad(r2,teta(i),phi(i),x_lambda_i)
        call rho_mult_nad(r3,teta(i))
        brf(1,1:nw)= r3+r1+r2
      end do
      end subroutine nadimbrf

