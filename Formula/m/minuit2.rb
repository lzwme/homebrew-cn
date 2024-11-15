class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https:root.cern.chdocmasterMinuit2Page.html"
  url "https:root.cern.chdownloadroot_v6.32.08.source.tar.gz"
  sha256 "29ad4945a72dff1a009c326a65b6fa5ee2478498823251d3cef86a2cbeb77b27"
  license "LGPL-2.1-or-later"
  head "https:github.comroot-projectroot.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6cc9e9cf66dd7ba5aa6c19108fe6c62c6c2b1d70d631d0d78805572f42181556"
    sha256 cellar: :any,                 arm64_sonoma:  "004c5ca7aadbeac120cd905b049c19afdd6dd180837b99056a032fd0cca6bfe5"
    sha256 cellar: :any,                 arm64_ventura: "292d02b1a45862254681282f5b83d92693f443cf7d518bf1e00bb1fcd627ef74"
    sha256 cellar: :any,                 sonoma:        "b0ab26a59b3da2dc229f3810727e8ba2c80ba9cff1bbaf0d5a2c7854ef6044a6"
    sha256 cellar: :any,                 ventura:       "8f2aeeae81a2a473dbfe183f516ee62f78efaf78b00b72bd6ee1f9bfb485fbdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11f869da8acef9fd626102548b04052e98f66b19ddd1f385d30cced50f978da"
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