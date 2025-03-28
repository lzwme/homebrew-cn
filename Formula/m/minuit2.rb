class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https:root.cern.chdocmasterMinuit2Page.html"
  url "https:root.cern.chdownloadroot_v6.34.06.source.tar.gz"
  sha256 "a799d632dae5bb1ec87eae6ebc046a12268c6849f2a8837921c118fc51b6cff3"
  license "LGPL-2.1-or-later"
  head "https:github.comroot-projectroot.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9ecb366c39ed6fc68429f7c6ae3749929f499e11fd91c7f4f016ee85bc1c4de"
    sha256 cellar: :any,                 arm64_sonoma:  "510fac586c053fb46a17ae42cabe82076795b36e0b2b9ed696c99081b57bc02a"
    sha256 cellar: :any,                 arm64_ventura: "76c4b96526f0a69f3a2700d4d32dccc0151b4e97a2b821707bac41158d3c496c"
    sha256 cellar: :any,                 sonoma:        "18e0e22b3304df6c21e9600ad40254745a7baad712f003e17c7ef8e8b081a0d3"
    sha256 cellar: :any,                 ventura:       "1588c7c66831ed805854180ac79463072b2400f8561670d0cedadc09a1983af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d064e8aef1681a59cb0442e1a8a0dc6a055cbd075b8528b79fb64a8ca5c5a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c083f4ad5f01bd3b6e86af60782a0c7f56cb8db74f4cd46e83c0782ec70dc318"
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