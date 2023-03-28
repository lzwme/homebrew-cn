class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://ghproxy.com/https://github.com/xianyi/OpenBLAS/archive/v0.3.22.tar.gz"
  sha256 "7fa9685926ba4f27cfe513adbf9af64d6b6b63f9dcabb37baefad6a65ff347a7"
  license "BSD-3-Clause"
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "54a6f0c4eb4b4890d5ba62a0a624f280709b06c82d2e85f176724991f573c076"
    sha256 cellar: :any,                 arm64_monterey: "9d113fd14d02330c044498f9808553fd39488791156aa1ef507b09527b825220"
    sha256 cellar: :any,                 arm64_big_sur:  "a04a7f1aadde9df20cb158bbe7da437e64024cc998ea46ade4c048e51f19054d"
    sha256 cellar: :any,                 ventura:        "ffca3fc43f03ccd5a1e7237b7a69babe3673ece29af42ac6fb39ff63f9ceb2b4"
    sha256 cellar: :any,                 monterey:       "88182242963dadab17203da329326f009e2eb383236969a4d25df1deb9d171eb"
    sha256 cellar: :any,                 big_sur:        "a75d72071fec3c9eb068d61f944e5bbaac95e27cf943b6e1763088d905189242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad8ebc1b409bdd90c5a1a9b0ea2cba138726fde2e4ba8286fe9a7d763442f7d3"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

  def install
    ENV.runtime_cpu_detection
    ENV.deparallelize # build is parallel by default, but setting -j confuses it

    # The build log has many warnings of macOS build version mismatches.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    ENV["DYNAMIC_ARCH"] = "1"
    ENV["USE_OPENMP"] = "1"
    # Force a large NUM_THREADS to support larger Macs than the VMs that build the bottles
    ENV["NUM_THREADS"] = "56"
    ENV["TARGET"] = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=gfortran", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "cblas.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas",
                   "-o", "test"
    system "./test"
  end
end