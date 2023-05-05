class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://ghproxy.com/https://github.com/SHTOOLS/SHTOOLS/releases/download/v4.10.2/SHTOOLS-4.10.2.tar.gz"
  sha256 "0caece67d65ddde19a79ec79bc6244f447f6fa878e5b2dc3f635cae2a3d1ee8c"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f16c09c4623a0d7deae19454be2e1b590f6ffb90a1fbbc11ef1514a35b02d092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef948bd0127544cfab21a58aabe0ce1c3a9020cba0b81248cb33bec82ae9fbf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d0b77c56bb480f3792325c51651ca6d62969cf8f1a9f7513ebf1eaa2816fbb4"
    sha256 cellar: :any_skip_relocation, ventura:        "4cd13a8a799bb5bcda372396c4f57af88533c6f5cf249aeb29c0093e4c14d226"
    sha256 cellar: :any_skip_relocation, monterey:       "e5210fa3aee34a84bf862bdf67b104ff34e84f9c889bd27557305054c67ffcbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b3dadc0808b8b8d4259fd24b9c0f4fe903e6d51ff88911cc06958c4dfe468f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "594b5746350c8287196755ce620aebd246b373ba95cc92dd82750914e00d4c5f"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "openblas"

  on_linux do
    depends_on "libtool" => :build
  end

  def install
    system "make", "fortran"
    system "make", "fortran-mp"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp_r "#{share}/examples/shtools", testpath
    system "make", "-C", "shtools/fortran",
                   "run-fortran-tests-no-timing",
                   "F95=gfortran",
                   "F95FLAGS=-m64 -fPIC -O3 -std=gnu -ffast-math",
                   "MODFLAG=-I#{HOMEBREW_PREFIX}/include",
                   "LIBPATH=#{HOMEBREW_PREFIX}/lib",
                   "LIBNAME=SHTOOLS",
                   "FFTW=-L #{HOMEBREW_PREFIX}/lib -lfftw3 -lm",
                   "LAPACK=-L #{Formula["openblas"].opt_lib} -lopenblas",
                   "BLAS="
  end
end