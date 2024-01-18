class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https:shtools.github.ioSHTOOLS"
  url "https:github.comSHTOOLSSHTOOLSarchiverefstagsv4.11.7.tar.gz"
  sha256 "855348aab0f807414187ac29c79faf6333ff3422f4c8912f1962d83538329251"
  license "BSD-3-Clause"
  head "https:github.comSHTOOLSSHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e8d031b5b4bc3918be379362c621d4e1add6531f24375aeb9f4c5dcf117609e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfd69532f700ba0d38ef0fdbb959a423d93a39928927dbab548c07a89739422e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9a0d13f99b713d9972d965b8b9be12220d56e87c4c6fe900dad413e4821f799"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b2be2e9677b103b7c96c2606c636fd6e845a244deffdf9da4014985df2d0077"
    sha256 cellar: :any_skip_relocation, ventura:        "5485a693386f957bae597821c560daeb6a102224f56ffe3a64bf096eb21ac1cb"
    sha256 cellar: :any_skip_relocation, monterey:       "da0fd386ca278bd142ef150486739a24b9521fbfe8dbe10fce9642e902a1b16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "400bb6e5b876242579bf49f2b1e1d372bd34fe080fe6e63760e5c83fc55d53b8"
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
    cp_r "#{share}examplesshtools", testpath
    system "make", "-C", "shtoolsfortran",
                   "run-fortran-tests-no-timing",
                   "F95=gfortran",
                   "F95FLAGS=-m64 -fPIC -O3 -std=gnu -ffast-math",
                   "MODFLAG=-I#{HOMEBREW_PREFIX}include",
                   "LIBPATH=#{HOMEBREW_PREFIX}lib",
                   "LIBNAME=SHTOOLS",
                   "FFTW=-L #{HOMEBREW_PREFIX}lib -lfftw3 -lm",
                   "LAPACK=-L #{Formula["openblas"].opt_lib} -lopenblas",
                   "BLAS="
  end
end