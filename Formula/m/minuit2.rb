class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.30.02.source.tar.gz"
  sha256 "7965a456d1ad1ee0d5fe4769bf5a8fec291af684ed93db0f3080a9c362435183"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46a6c3ab833507b369ddaa8f01a17675f6be756a80397ad7352941dcc4fd715e"
    sha256 cellar: :any,                 arm64_ventura:  "647a86580b40ceceb93ef633a11f48827b8ff5ff6b0a0f3fc10a019dbcd38731"
    sha256 cellar: :any,                 arm64_monterey: "e047993fecb18867605f023cdac53f4b4e389d79e71ce67b75fdf5d66fd04c3e"
    sha256 cellar: :any,                 sonoma:         "7c1c22861e9f17a9145ccd5b73f176f57096c3715d7b53fbcee882388423208e"
    sha256 cellar: :any,                 ventura:        "12c9da2afbca594f7bc41f8fcb4917135ccd885e38a560351b65ee2911254c47"
    sha256 cellar: :any,                 monterey:       "f292777a6f6a7a89f1d5d677a21cdfaab6623b616a03960fd901b1c23154190e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "202f11a06135d0b0b556135238ba974282a939a15c6814c071c230ff03639b8e"
  end

  depends_on "cmake" => :build

  # Fix VERSION_FILE path for standalone mode
  # Remove in next release
  patch do
    url "https://github.com/root-project/root/commit/25731a7b0731a65f6a949dd249b098fdd612095d.patch?full_index=1"
    sha256 "058daafb2103b43b9d7775f895f16992050ba339083e844124c551ce9133b0a3"
  end

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++14", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end