class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https:www.dynare.org"
  url "https:www.dynare.orgreleasesourcedynare-6.2.tar.xz"
  sha256 "312a3358bb0735f09b13f996e2d32cfd297292201897c1075c399554398862d9"
  license "GPL-3.0-or-later"
  revision 2
  head "https:git.dynare.orgDynaredynare.git", branch: "master"

  livecheck do
    url "https:www.dynare.orgdownload"
    regex(href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "8b5388cca3b98fd344e0346e8fcc9ed41700e7b6f5dcd671c6705641bd91ec15"
    sha256 cellar: :any, arm64_ventura: "da223cdcbae0ec6218cf040e5aa197ff297ee1bf80160262b7b3dd23433908ac"
    sha256 cellar: :any, sonoma:        "85920bdde7805b5e59ad1cf24aa62311e1e7877ba60fcde2f7ac5d97820b5c3a"
    sha256 cellar: :any, ventura:       "618ce3ccc9d9642c654ce9a0e8f9c0766820e45a5086f4ed8202e8d391983c82"
    sha256               x86_64_linux:  "548e872a386bfb6cb4ffccea9a1f223aeb22643ba89f773cc8dff575aa40e705"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "octave"
  depends_on "openblas"
  depends_on "suite-sparse"

  fails_with :clang do
    cause <<~EOS
      GCC is the only compiler supported by upstream
      https:git.dynare.orgDynaredynare-blobmasterREADME.md#general-instructions
    EOS
  end

  resource "slicot" do
    url "https:deb.debian.orgdebianpoolmainsslicotslicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  def install
    resource("slicot").stage do
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=..libslicot_pic.a",
             "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
             "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=..libslicot64_pic.a"
      (buildpath"slicotlib").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    # Work around used in upstream builds which helps avoid runtime preprocessor error.
    # https:git.dynare.orgDynaredynare-blobmastermacOShomebrew-native-arm64.ini
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # Help meson find `suite-sparse` and `slicot`
    ENV.append_path "LIBRARY_PATH", Formula["suite-sparse"].opt_lib
    ENV.append_path "LIBRARY_PATH", buildpath"slicotlib"

    system "meson", "setup", "build", "-Dbuild_for=octave", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (pkgshare"examples").install "examplesbkk.mod"
  end

  def caveats
    <<~EOS
      To get started with Dynare, open Octave and type
        addpath #{opt_lib}dynarematlab
    EOS
  end

  test do
    resource "statistics" do
      url "https:github.comgnu-octavestatisticsarchiverefstagsrelease-1.6.5.tar.gz", using: :nounzip
      sha256 "0ea8258c92ce67e1bb75a9813b7ceb56fff1dacf6c47236d3da776e27b684cee"
    end

    ENV.cxx11
    ENV.delete "LDFLAGS" # avoid overriding Octave flags

    # Work around Xcode 15.0 ld error with GCC: https:github.comHomebrewhomebrew-coreissues145991
    if OS.mac? && (MacOS::Xcode.version.to_s.start_with?("15.0") || MacOS::CLT.version.to_s.start_with?("15.0"))
      ENV["LDFLAGS"] = shell_output("#{Formula["octave"].opt_bin}mkoctfile --print LDFLAGS").chomp
      ENV.append "LDFLAGS", "-Wl,-ld_classic"
    end

    statistics = resource("statistics")
    testpath.install statistics

    cp pkgshare"examplesbkk.mod", testpath

    # Replace `makeinfo` with dummy command `true` to prevent generating docs
    # that are not useful to the test.
    (testpath"dyn_test.m").write <<~MATLAB
      makeinfo_program true
      pkg prefix #{testpath}octave
      pkg install statistics-release-#{statistics.version}.tar.gz
      dynare bkk.mod console
    MATLAB

    system Formula["octave"].opt_bin"octave", "--no-gui",
           "--no-history", "--path", "#{lib}dynarematlab", "dyn_test.m"
  end
end