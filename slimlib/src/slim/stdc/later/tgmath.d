/**
 * D header file for C99.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
 * Authors:   Sean Kelly
 * Standards: ISO/IEC 9899:1999 (E)
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module slim.stdc.tgmath;

private import slim.stdc.config;
private static import slim.stdc.math;
private static import slim.stdc.complex;

extern (C):

version( FreeBSD )
{
    alias slim.stdc.math.acos          acos;
    alias slim.stdc.math.acosf         acos;
    alias slim.stdc.math.acosl         acos;

    alias slim.stdc.complex.cacos      acos;
    alias slim.stdc.complex.cacosf     acos;
    alias slim.stdc.complex.cacosl     acos;

    alias slim.stdc.math.asin          asin;
    alias slim.stdc.math.asinf         asin;
    alias slim.stdc.math.asinl         asin;

    alias slim.stdc.complex.casin      asin;
    alias slim.stdc.complex.casinf     asin;
    alias slim.stdc.complex.casinl     asin;

    alias slim.stdc.math.atan          atan;
    alias slim.stdc.math.atanf         atan;
    alias slim.stdc.math.atanl         atan;

    alias slim.stdc.complex.catan      atan;
    alias slim.stdc.complex.catanf     atan;
    alias slim.stdc.complex.catanl     atan;

    alias slim.stdc.math.atan2         atan2;
    alias slim.stdc.math.atan2f        atan2;
    alias slim.stdc.math.atan2l        atan2;

    alias slim.stdc.math.cos           cos;
    alias slim.stdc.math.cosf          cos;
    alias slim.stdc.math.cosl          cos;

    alias slim.stdc.complex.ccos       cos;
    alias slim.stdc.complex.ccosf      cos;
    alias slim.stdc.complex.ccosl      cos;

    alias slim.stdc.math.sin           sin;
    alias slim.stdc.math.sinf          sin;
    alias slim.stdc.math.sinl          sin;

    alias slim.stdc.complex.csin       csin;
    alias slim.stdc.complex.csinf      csin;
    alias slim.stdc.complex.csinl      csin;

    alias slim.stdc.math.tan           tan;
    alias slim.stdc.math.tanf          tan;
    alias slim.stdc.math.tanl          tan;

    alias slim.stdc.complex.ctan       tan;
    alias slim.stdc.complex.ctanf      tan;
    alias slim.stdc.complex.ctanl      tan;

    alias slim.stdc.math.acosh         acosh;
    alias slim.stdc.math.acoshf        acosh;
    alias slim.stdc.math.acoshl        acosh;

    alias slim.stdc.complex.cacosh     acosh;
    alias slim.stdc.complex.cacoshf    acosh;
    alias slim.stdc.complex.cacoshl    acosh;

    alias slim.stdc.math.asinh         asinh;
    alias slim.stdc.math.asinhf        asinh;
    alias slim.stdc.math.asinhl        asinh;

    alias slim.stdc.complex.casinh     asinh;
    alias slim.stdc.complex.casinhf    asinh;
    alias slim.stdc.complex.casinhl    asinh;

    alias slim.stdc.math.atanh         atanh;
    alias slim.stdc.math.atanhf        atanh;
    alias slim.stdc.math.atanhl        atanh;

    alias slim.stdc.complex.catanh     atanh;
    alias slim.stdc.complex.catanhf    atanh;
    alias slim.stdc.complex.catanhl    atanh;

    alias slim.stdc.math.cosh          cosh;
    alias slim.stdc.math.coshf         cosh;
    alias slim.stdc.math.coshl         cosh;

    alias slim.stdc.complex.ccosh      cosh;
    alias slim.stdc.complex.ccoshf     cosh;
    alias slim.stdc.complex.ccoshl     cosh;

    alias slim.stdc.math.sinh          sinh;
    alias slim.stdc.math.sinhf         sinh;
    alias slim.stdc.math.sinhl         sinh;

    alias slim.stdc.complex.csinh      sinh;
    alias slim.stdc.complex.csinhf     sinh;
    alias slim.stdc.complex.csinhl     sinh;

    alias slim.stdc.math.tanh          tanh;
    alias slim.stdc.math.tanhf         tanh;
    alias slim.stdc.math.tanhl         tanh;

    alias slim.stdc.complex.ctanh      tanh;
    alias slim.stdc.complex.ctanhf     tanh;
    alias slim.stdc.complex.ctanhl     tanh;

    alias slim.stdc.math.exp           exp;
    alias slim.stdc.math.expf          exp;
    alias slim.stdc.math.expl          exp;

    alias slim.stdc.complex.cexp       exp;
    alias slim.stdc.complex.cexpf      exp;
    alias slim.stdc.complex.cexpl      exp;

    alias slim.stdc.math.exp2          exp2;
    alias slim.stdc.math.exp2f         exp2;
    alias slim.stdc.math.exp2l         exp2;

    alias slim.stdc.math.expm1         expm1;
    alias slim.stdc.math.expm1f        expm1;
    alias slim.stdc.math.expm1l        expm1;

    alias slim.stdc.math.frexp         frexp;
    alias slim.stdc.math.frexpf        frexp;
    alias slim.stdc.math.frexpl        frexp;

    alias slim.stdc.math.ilogb         ilogb;
    alias slim.stdc.math.ilogbf        ilogb;
    alias slim.stdc.math.ilogbl        ilogb;

    alias slim.stdc.math.ldexp         ldexp;
    alias slim.stdc.math.ldexpf        ldexp;
    alias slim.stdc.math.ldexpl        ldexp;

    alias slim.stdc.math.log           log;
    alias slim.stdc.math.logf          log;
    alias slim.stdc.math.logl          log;

    alias slim.stdc.complex.clog       log;
    alias slim.stdc.complex.clogf      log;
    alias slim.stdc.complex.clogl      log;

    alias slim.stdc.math.log10         log10;
    alias slim.stdc.math.log10f        log10;
    alias slim.stdc.math.log10l        log10;

    alias slim.stdc.math.log1p         log1p;
    alias slim.stdc.math.log1pf        log1p;
    alias slim.stdc.math.log1pl        log1p;

    alias slim.stdc.math.log2          log1p;
    alias slim.stdc.math.log2f         log1p;
    alias slim.stdc.math.log2l         log1p;

    alias slim.stdc.math.logb          log1p;
    alias slim.stdc.math.logbf         log1p;
    alias slim.stdc.math.logbl         log1p;

    alias slim.stdc.math.modf          modf;
    alias slim.stdc.math.modff         modf;
//  alias slim.stdc.math.modfl         modf;

    alias slim.stdc.math.scalbn        scalbn;
    alias slim.stdc.math.scalbnf       scalbn;
    alias slim.stdc.math.scalbnl       scalbn;

    alias slim.stdc.math.scalbln       scalbln;
    alias slim.stdc.math.scalblnf      scalbln;
    alias slim.stdc.math.scalblnl      scalbln;

    alias slim.stdc.math.cbrt          cbrt;
    alias slim.stdc.math.cbrtf         cbrt;
    alias slim.stdc.math.cbrtl         cbrt;

    alias slim.stdc.math.fabs          fabs;
    alias slim.stdc.math.fabsf         fabs;
    alias slim.stdc.math.fabsl         fabs;

    alias slim.stdc.complex.cabs       fabs;
    alias slim.stdc.complex.cabsf      fabs;
    alias slim.stdc.complex.cabsl      fabs;

    alias slim.stdc.math.hypot         hypot;
    alias slim.stdc.math.hypotf        hypot;
    alias slim.stdc.math.hypotl        hypot;

    alias slim.stdc.math.pow           pow;
    alias slim.stdc.math.powf          pow;
    alias slim.stdc.math.powl          pow;

    alias slim.stdc.complex.cpow       pow;
    alias slim.stdc.complex.cpowf      pow;
    alias slim.stdc.complex.cpowl      pow;

    alias slim.stdc.math.sqrt          sqrt;
    alias slim.stdc.math.sqrtf         sqrt;
    alias slim.stdc.math.sqrtl         sqrt;

    alias slim.stdc.complex.csqrt      sqrt;
    alias slim.stdc.complex.csqrtf     sqrt;
    alias slim.stdc.complex.csqrtl     sqrt;

    alias slim.stdc.math.erf           erf;
    alias slim.stdc.math.erff          erf;
    alias slim.stdc.math.erfl          erf;

    alias slim.stdc.math.erfc          erfc;
    alias slim.stdc.math.erfcf         erfc;
    alias slim.stdc.math.erfcl         erfc;

    alias slim.stdc.math.lgamma        lgamma;
    alias slim.stdc.math.lgammaf       lgamma;
    alias slim.stdc.math.lgammal       lgamma;

    alias slim.stdc.math.tgamma        tgamma;
    alias slim.stdc.math.tgammaf       tgamma;
    alias slim.stdc.math.tgammal       tgamma;

    alias slim.stdc.math.ceil          ceil;
    alias slim.stdc.math.ceilf         ceil;
    alias slim.stdc.math.ceill         ceil;

    alias slim.stdc.math.floor         floor;
    alias slim.stdc.math.floorf        floor;
    alias slim.stdc.math.floorl        floor;

    alias slim.stdc.math.nearbyint     nearbyint;
    alias slim.stdc.math.nearbyintf    nearbyint;
    alias slim.stdc.math.nearbyintl    nearbyint;

    alias slim.stdc.math.rint          rint;
    alias slim.stdc.math.rintf         rint;
    alias slim.stdc.math.rintl         rint;

    alias slim.stdc.math.lrint         lrint;
    alias slim.stdc.math.lrintf        lrint;
    alias slim.stdc.math.lrintl        lrint;

    alias slim.stdc.math.llrint        llrint;
    alias slim.stdc.math.llrintf       llrint;
    alias slim.stdc.math.llrintl       llrint;

    alias slim.stdc.math.round         round;
    alias slim.stdc.math.roundf        round;
    alias slim.stdc.math.roundl        round;

    alias slim.stdc.math.lround        lround;
    alias slim.stdc.math.lroundf       lround;
    alias slim.stdc.math.lroundl       lround;

    alias slim.stdc.math.llround       llround;
    alias slim.stdc.math.llroundf      llround;
    alias slim.stdc.math.llroundl      llround;

    alias slim.stdc.math.trunc         trunc;
    alias slim.stdc.math.truncf        trunc;
    alias slim.stdc.math.truncl        trunc;

    alias slim.stdc.math.fmod          fmod;
    alias slim.stdc.math.fmodf         fmod;
    alias slim.stdc.math.fmodl         fmod;

    alias slim.stdc.math.remainder     remainder;
    alias slim.stdc.math.remainderf    remainder;
    alias slim.stdc.math.remainderl    remainder;

    alias slim.stdc.math.remquo        remquo;
    alias slim.stdc.math.remquof       remquo;
    alias slim.stdc.math.remquol       remquo;

    alias slim.stdc.math.copysign      copysign;
    alias slim.stdc.math.copysignf     copysign;
    alias slim.stdc.math.copysignl     copysign;

//  alias slim.stdc.math.nan           nan;
//  alias slim.stdc.math.nanf          nan;
//  alias slim.stdc.math.nanl          nan;

    alias slim.stdc.math.nextafter     nextafter;
    alias slim.stdc.math.nextafterf    nextafter;
    alias slim.stdc.math.nextafterl    nextafter;

    alias slim.stdc.math.nexttoward    nexttoward;
    alias slim.stdc.math.nexttowardf   nexttoward;
    alias slim.stdc.math.nexttowardl   nexttoward;

    alias slim.stdc.math.fdim          fdim;
    alias slim.stdc.math.fdimf         fdim;
    alias slim.stdc.math.fdiml         fdim;

    alias slim.stdc.math.fmax          fmax;
    alias slim.stdc.math.fmaxf         fmax;
    alias slim.stdc.math.fmaxl         fmax;

    alias slim.stdc.math.fmin          fmin;
    alias slim.stdc.math.fmin          fmin;
    alias slim.stdc.math.fminl         fmin;

    alias slim.stdc.math.fma           fma;
    alias slim.stdc.math.fmaf          fma;
    alias slim.stdc.math.fmal          fma;

    alias slim.stdc.complex.carg       carg;
    alias slim.stdc.complex.cargf      carg;
    alias slim.stdc.complex.cargl      carg;

    alias slim.stdc.complex.cimag      cimag;
    alias slim.stdc.complex.cimagf     cimag;
    alias slim.stdc.complex.cimagl     cimag;

    alias slim.stdc.complex.conj       conj;
    alias slim.stdc.complex.conjf      conj;
    alias slim.stdc.complex.conjl      conj;

    alias slim.stdc.complex.cproj      cproj;
    alias slim.stdc.complex.cprojf     cproj;
    alias slim.stdc.complex.cprojl     cproj;

//  alias slim.stdc.complex.creal      creal;
//  alias slim.stdc.complex.crealf     creal;
//  alias slim.stdc.complex.creall     creal;
}
else
{
    alias slim.stdc.math.acos          acos;
    alias slim.stdc.math.acosf         acos;
    alias slim.stdc.math.acosl         acos;

    alias slim.stdc.complex.cacos      acos;
    alias slim.stdc.complex.cacosf     acos;
    alias slim.stdc.complex.cacosl     acos;

    alias slim.stdc.math.asin          asin;
    alias slim.stdc.math.asinf         asin;
    alias slim.stdc.math.asinl         asin;

    alias slim.stdc.complex.casin      asin;
    alias slim.stdc.complex.casinf     asin;
    alias slim.stdc.complex.casinl     asin;

    alias slim.stdc.math.atan          atan;
    alias slim.stdc.math.atanf         atan;
    alias slim.stdc.math.atanl         atan;

    alias slim.stdc.complex.catan      atan;
    alias slim.stdc.complex.catanf     atan;
    alias slim.stdc.complex.catanl     atan;

    alias slim.stdc.math.atan2         atan2;
    alias slim.stdc.math.atan2f        atan2;
    alias slim.stdc.math.atan2l        atan2;

    alias slim.stdc.math.cos           cos;
    alias slim.stdc.math.cosf          cos;
    alias slim.stdc.math.cosl          cos;

    alias slim.stdc.complex.ccos       cos;
    alias slim.stdc.complex.ccosf      cos;
    alias slim.stdc.complex.ccosl      cos;

    alias slim.stdc.math.sin           sin;
    alias slim.stdc.math.sinf          sin;
    alias slim.stdc.math.sinl          sin;

    alias slim.stdc.complex.csin       csin;
    alias slim.stdc.complex.csinf      csin;
    alias slim.stdc.complex.csinl      csin;

    alias slim.stdc.math.tan           tan;
    alias slim.stdc.math.tanf          tan;
    alias slim.stdc.math.tanl          tan;

    alias slim.stdc.complex.ctan       tan;
    alias slim.stdc.complex.ctanf      tan;
    alias slim.stdc.complex.ctanl      tan;

    alias slim.stdc.math.acosh         acosh;
    alias slim.stdc.math.acoshf        acosh;
    alias slim.stdc.math.acoshl        acosh;

    alias slim.stdc.complex.cacosh     acosh;
    alias slim.stdc.complex.cacoshf    acosh;
    alias slim.stdc.complex.cacoshl    acosh;

    alias slim.stdc.math.asinh         asinh;
    alias slim.stdc.math.asinhf        asinh;
    alias slim.stdc.math.asinhl        asinh;

    alias slim.stdc.complex.casinh     asinh;
    alias slim.stdc.complex.casinhf    asinh;
    alias slim.stdc.complex.casinhl    asinh;

    alias slim.stdc.math.atanh         atanh;
    alias slim.stdc.math.atanhf        atanh;
    alias slim.stdc.math.atanhl        atanh;

    alias slim.stdc.complex.catanh     atanh;
    alias slim.stdc.complex.catanhf    atanh;
    alias slim.stdc.complex.catanhl    atanh;

    alias slim.stdc.math.cosh          cosh;
    alias slim.stdc.math.coshf         cosh;
    alias slim.stdc.math.coshl         cosh;

    alias slim.stdc.complex.ccosh      cosh;
    alias slim.stdc.complex.ccoshf     cosh;
    alias slim.stdc.complex.ccoshl     cosh;

    alias slim.stdc.math.sinh          sinh;
    alias slim.stdc.math.sinhf         sinh;
    alias slim.stdc.math.sinhl         sinh;

    alias slim.stdc.complex.csinh      sinh;
    alias slim.stdc.complex.csinhf     sinh;
    alias slim.stdc.complex.csinhl     sinh;

    alias slim.stdc.math.tanh          tanh;
    alias slim.stdc.math.tanhf         tanh;
    alias slim.stdc.math.tanhl         tanh;

    alias slim.stdc.complex.ctanh      tanh;
    alias slim.stdc.complex.ctanhf     tanh;
    alias slim.stdc.complex.ctanhl     tanh;

    alias slim.stdc.math.exp           exp;
    alias slim.stdc.math.expf          exp;
    alias slim.stdc.math.expl          exp;

    alias slim.stdc.complex.cexp       exp;
    alias slim.stdc.complex.cexpf      exp;
    alias slim.stdc.complex.cexpl      exp;

    alias slim.stdc.math.exp2          exp2;
    alias slim.stdc.math.exp2f         exp2;
    alias slim.stdc.math.exp2l         exp2;

    alias slim.stdc.math.expm1         expm1;
    alias slim.stdc.math.expm1f        expm1;
    alias slim.stdc.math.expm1l        expm1;

    alias slim.stdc.math.frexp         frexp;
    alias slim.stdc.math.frexpf        frexp;
    alias slim.stdc.math.frexpl        frexp;

    alias slim.stdc.math.ilogb         ilogb;
    alias slim.stdc.math.ilogbf        ilogb;
    alias slim.stdc.math.ilogbl        ilogb;

    alias slim.stdc.math.ldexp         ldexp;
    alias slim.stdc.math.ldexpf        ldexp;
    alias slim.stdc.math.ldexpl        ldexp;

    alias slim.stdc.math.log           log;
    alias slim.stdc.math.logf          log;
    alias slim.stdc.math.logl          log;

    alias slim.stdc.complex.clog       log;
    alias slim.stdc.complex.clogf      log;
    alias slim.stdc.complex.clogl      log;

    alias slim.stdc.math.log10         log10;
    alias slim.stdc.math.log10f        log10;
    alias slim.stdc.math.log10l        log10;

    alias slim.stdc.math.log1p         log1p;
    alias slim.stdc.math.log1pf        log1p;
    alias slim.stdc.math.log1pl        log1p;

    alias slim.stdc.math.log2          log1p;
    alias slim.stdc.math.log2f         log1p;
    alias slim.stdc.math.log2l         log1p;

    alias slim.stdc.math.logb          log1p;
    alias slim.stdc.math.logbf         log1p;
    alias slim.stdc.math.logbl         log1p;

    alias slim.stdc.math.modf          modf;
    alias slim.stdc.math.modff         modf;
    alias slim.stdc.math.modfl         modf;

    alias slim.stdc.math.scalbn        scalbn;
    alias slim.stdc.math.scalbnf       scalbn;
    alias slim.stdc.math.scalbnl       scalbn;

    alias slim.stdc.math.scalbln       scalbln;
    alias slim.stdc.math.scalblnf      scalbln;
    alias slim.stdc.math.scalblnl      scalbln;

    alias slim.stdc.math.cbrt          cbrt;
    alias slim.stdc.math.cbrtf         cbrt;
    alias slim.stdc.math.cbrtl         cbrt;

    alias slim.stdc.math.fabs          fabs;
    alias slim.stdc.math.fabsf         fabs;
    alias slim.stdc.math.fabsl         fabs;

    alias slim.stdc.complex.cabs       fabs;
    alias slim.stdc.complex.cabsf      fabs;
    alias slim.stdc.complex.cabsl      fabs;

    alias slim.stdc.math.hypot         hypot;
    alias slim.stdc.math.hypotf        hypot;
    alias slim.stdc.math.hypotl        hypot;

    alias slim.stdc.math.pow           pow;
    alias slim.stdc.math.powf          pow;
    alias slim.stdc.math.powl          pow;

    alias slim.stdc.complex.cpow       pow;
    alias slim.stdc.complex.cpowf      pow;
    alias slim.stdc.complex.cpowl      pow;

    alias slim.stdc.math.sqrt          sqrt;
    alias slim.stdc.math.sqrtf         sqrt;
    alias slim.stdc.math.sqrtl         sqrt;

    alias slim.stdc.complex.csqrt      sqrt;
    alias slim.stdc.complex.csqrtf     sqrt;
    alias slim.stdc.complex.csqrtl     sqrt;

    alias slim.stdc.math.erf           erf;
    alias slim.stdc.math.erff          erf;
    alias slim.stdc.math.erfl          erf;

    alias slim.stdc.math.erfc          erfc;
    alias slim.stdc.math.erfcf         erfc;
    alias slim.stdc.math.erfcl         erfc;

    alias slim.stdc.math.lgamma        lgamma;
    alias slim.stdc.math.lgammaf       lgamma;
    alias slim.stdc.math.lgammal       lgamma;

    alias slim.stdc.math.tgamma        tgamma;
    alias slim.stdc.math.tgammaf       tgamma;
    alias slim.stdc.math.tgammal       tgamma;

    alias slim.stdc.math.ceil          ceil;
    alias slim.stdc.math.ceilf         ceil;
    alias slim.stdc.math.ceill         ceil;

    alias slim.stdc.math.floor         floor;
    alias slim.stdc.math.floorf        floor;
    alias slim.stdc.math.floorl        floor;

    alias slim.stdc.math.nearbyint     nearbyint;
    alias slim.stdc.math.nearbyintf    nearbyint;
    alias slim.stdc.math.nearbyintl    nearbyint;

    alias slim.stdc.math.rint          rint;
    alias slim.stdc.math.rintf         rint;
    alias slim.stdc.math.rintl         rint;

    alias slim.stdc.math.lrint         lrint;
    alias slim.stdc.math.lrintf        lrint;
    alias slim.stdc.math.lrintl        lrint;

    alias slim.stdc.math.llrint        llrint;
    alias slim.stdc.math.llrintf       llrint;
    alias slim.stdc.math.llrintl       llrint;

    alias slim.stdc.math.round         round;
    alias slim.stdc.math.roundf        round;
    alias slim.stdc.math.roundl        round;

    alias slim.stdc.math.lround        lround;
    alias slim.stdc.math.lroundf       lround;
    alias slim.stdc.math.lroundl       lround;

    alias slim.stdc.math.llround       llround;
    alias slim.stdc.math.llroundf      llround;
    alias slim.stdc.math.llroundl      llround;

    alias slim.stdc.math.trunc         trunc;
    alias slim.stdc.math.truncf        trunc;
    alias slim.stdc.math.truncl        trunc;

    alias slim.stdc.math.fmod          fmod;
    alias slim.stdc.math.fmodf         fmod;
    alias slim.stdc.math.fmodl         fmod;

    alias slim.stdc.math.remainder     remainder;
    alias slim.stdc.math.remainderf    remainder;
    alias slim.stdc.math.remainderl    remainder;

    alias slim.stdc.math.remquo        remquo;
    alias slim.stdc.math.remquof       remquo;
    alias slim.stdc.math.remquol       remquo;

    alias slim.stdc.math.copysign      copysign;
    alias slim.stdc.math.copysignf     copysign;
    alias slim.stdc.math.copysignl     copysign;

    alias slim.stdc.math.nan           nan;
    alias slim.stdc.math.nanf          nan;
    alias slim.stdc.math.nanl          nan;

    alias slim.stdc.math.nextafter     nextafter;
    alias slim.stdc.math.nextafterf    nextafter;
    alias slim.stdc.math.nextafterl    nextafter;

    alias slim.stdc.math.nexttoward    nexttoward;
    alias slim.stdc.math.nexttowardf   nexttoward;
    alias slim.stdc.math.nexttowardl   nexttoward;

    alias slim.stdc.math.fdim          fdim;
    alias slim.stdc.math.fdimf         fdim;
    alias slim.stdc.math.fdiml         fdim;

    alias slim.stdc.math.fmax          fmax;
    alias slim.stdc.math.fmaxf         fmax;
    alias slim.stdc.math.fmaxl         fmax;

    alias slim.stdc.math.fmin          fmin;
    alias slim.stdc.math.fmin          fmin;
    alias slim.stdc.math.fminl         fmin;

    alias slim.stdc.math.fma           fma;
    alias slim.stdc.math.fmaf          fma;
    alias slim.stdc.math.fmal          fma;

    alias slim.stdc.complex.carg       carg;
    alias slim.stdc.complex.cargf      carg;
    alias slim.stdc.complex.cargl      carg;

    alias slim.stdc.complex.cimag      cimag;
    alias slim.stdc.complex.cimagf     cimag;
    alias slim.stdc.complex.cimagl     cimag;

    alias slim.stdc.complex.conj       conj;
    alias slim.stdc.complex.conjf      conj;
    alias slim.stdc.complex.conjl      conj;

    alias slim.stdc.complex.cproj      cproj;
    alias slim.stdc.complex.cprojf     cproj;
    alias slim.stdc.complex.cprojl     cproj;

//  alias slim.stdc.complex.creal      creal;
//  alias slim.stdc.complex.crealf     creal;
//  alias slim.stdc.complex.creall     creal;
}
