class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https:root.cern.chdocmasterMinuit2Page.html"
  license "LGPL-2.1-or-later"
  head "https:github.comroot-projectroot.git", branch: "master"

  stable do
    url "https:root.cern.chdownloadroot_v6.34.00.source.tar.gz"
    sha256 "f3b00f3db953829c849029c39d7660a956468af247efd946e89072101796ab03"

    # TODO: Remove this patch when updating to the next version after 6.34.00.
    patch do
      url "https:github.comroot-projectrootcommit3ee43dd22d84c92de17d4139100af17ac35c0501.patch?full_index=1"
      sha256 "38328c9734dace642aef4dfc92a90e8584304319dcef36915d233b1c596945c4"
    end
  end

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb5928372140347bd2d26eb48017392ec312ff12202aea0ba0c724e732d40676"
    sha256 cellar: :any,                 arm64_sonoma:  "2367b47560840df33e4cae3feca0a6f6bc3526dd0fdddde19051e7d461e05ab9"
    sha256 cellar: :any,                 arm64_ventura: "be84772771279aa1a6bcf83aac6d0c9d364fe9902786757e799c1908ae80cc31"
    sha256 cellar: :any,                 sonoma:        "c08006671bd080e0c242aaa2587009b8f886a285090de58118cbbec35d9079d4"
    sha256 cellar: :any,                 ventura:       "fd8237ad6d744d2aca19566a21cce1a52919cb0296d7b1db6be3cd6a15a7f217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3194717c59675218f432e043b9a9b2436e80e9beffcdc10ba0c24e9e43b3b3e"
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