class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https:root.cern.chdocmasterMinuit2Page.html"
  url "https:root.cern.chdownloadroot_v6.32.02.source.tar.gz"
  sha256 "3d0f76bf05857e1807ccfb2c9e014f525bcb625f94a2370b455f4b164961602d"
  license "LGPL-2.1-or-later"
  head "https:github.comroot-projectroot.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da74469d373322e868ea729dc5d0cd794778d24f9cfb19c792b3f223ef36472c"
    sha256 cellar: :any,                 arm64_ventura:  "1b996d22e9310fe4790a2ab35634430949fe1ce67ef739bbc1d6bf888447e6db"
    sha256 cellar: :any,                 arm64_monterey: "fba29346791305f94a67c5552c3bd4c530683e0e37b60f23e54fb9de5afe45c8"
    sha256 cellar: :any,                 sonoma:         "943b3970fe053e862f39e34f7694be2a1068104e0b3353007b56740ceb436663"
    sha256 cellar: :any,                 ventura:        "066d28d8282269edbf4e9e3edbf2bd77265ad8dd57bddc905e963e735cb56593"
    sha256 cellar: :any,                 monterey:       "691115d811ce4beb9d4365ce727cd5b14e88d1eefe7cd361c9dd5b0a69a3ed86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e144862c6bf58969a74754f6c7c96c24a8c63c590a36bd3e64fa9b46a41088f5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "mathminuit2", "-B", "buildshared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", "mathminuit2", "-B", "buildstatic", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "buildstatic"
    lib.install Dir["buildstaticliblibMinuit2*.a"]

    pkgshare.install "mathminuit2testMnTutorial"
  end

  test do
    cp Dir[pkgshare"MnTutorial{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++14", "Quad1FMain.cxx", "-o", "test", "-I#{include}Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output(".test")
  end
end