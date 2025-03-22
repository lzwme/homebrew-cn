class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https:root.cern.chdocmasterMinuit2Page.html"
  url "https:root.cern.chdownloadroot_v6.34.04.source.tar.gz"
  sha256 "e320c5373a8e87bb29b7280954ca8355ad8c4295cf49235606f0c8b200acb374"
  license "LGPL-2.1-or-later"
  head "https:github.comroot-projectroot.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1117ef70fb2c427a6a0ed55df2c20423d6ac3d8cad29731d96128732bd2fab46"
    sha256 cellar: :any,                 arm64_sonoma:  "ab416f13a2e2ec8d9eb106ada5ff643e6256ebcc18a0a5520574de3be7b52dac"
    sha256 cellar: :any,                 arm64_ventura: "ddad4d26a85e5c4bcd15e3014f02179059a42a92c004d31509523c53374847b3"
    sha256 cellar: :any,                 sonoma:        "8aba5f781e598f9508715ba123eff3dc4bde469288e68660b889310256405c04"
    sha256 cellar: :any,                 ventura:       "f1937f7bf040e3c64db5285c71b8ce20da47cd0d5e374e2adb80dc0ab891503b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01059a2023a799f40093a7cb591269eea4fbdc3c4126f2c34f05f656f71b1a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "343a3d458c5cac6b9f15f40cc983afd668f4b65ae7fe9c9056b602371a5024ec"
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