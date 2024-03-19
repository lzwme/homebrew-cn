class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https:www.dynare.org"
  url "https:www.dynare.orgreleasesourcedynare-6.0.tar.xz"
  sha256 "52460046d44776d936986f52649f9e48966b07e414a864d83531d43e568ab682"
  license "GPL-3.0-or-later"
  revision 1
  head "https:git.dynare.orgDynaredynare.git", branch: "master"

  livecheck do
    url "https:www.dynare.orgdownload"
    regex(href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "735082a3de132613ae2e5f7f9542fa975cb803c76bd4a9b68f9ccb751f5704ba"
    sha256 cellar: :any, arm64_ventura:  "fb562b6f3876ca77cbd36dd54726ff38611a790ef6a78688ed5b30af11877440"
    sha256 cellar: :any, arm64_monterey: "b81c27f5924f1c290e8d8cc5313eda11a0896d80b816188ae14f1f5b7de0a6e8"
    sha256 cellar: :any, sonoma:         "f8bc049be241b5383e8656dc2bcf34026ad340ab448db335d4279407343d90cc"
    sha256 cellar: :any, ventura:        "48db2ccf885cb0af1504ebab996c89f901f7a2dabbbf03238e401df44e9ef60b"
    sha256 cellar: :any, monterey:       "0e2108b2f154027e78bb246d64b48cea7225a770dc8dc3d6167ff8e905062a7f"
    sha256               x86_64_linux:   "c19a7ece62c121e7b91637b553dd5661e7594cb25dfdd07395890c0fc907f1c2"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
      url "https:github.comgnu-octavestatisticsarchiverefstagsrelease-1.6.3.tar.gz", using: :nounzip
      sha256 "71ea088e23274a3d24cb24a93f9e5d3dae4649951da5ff762caea626983ded95"
    end

    ENV.cxx11

    statistics = resource("statistics")
    testpath.install statistics

    cp pkgshare"examplesbkk.mod", testpath

    # Replace `makeinfo` with dummy command `true` to prevent generating docs
    # that are not useful to the test.
    (testpath"dyn_test.m").write <<~EOS
      makeinfo_program true
      pkg prefix #{testpath}octave
      pkg install statistics-release-#{statistics.version}.tar.gz
      dynare bkk.mod console
    EOS

    system Formula["octave"].opt_bin"octave", "--no-gui",
           "-H", "--path", "#{lib}dynarematlab", "dyn_test.m"
  end
end