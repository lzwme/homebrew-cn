class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.38.02.source.tar.gz"
  sha256 "77d34d2bca0ea720acfd43798bcb5d09a28584013b4d0a2910823c867d4bfa42"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db2f5fafc753ead3e5679f493e733c5d8d1190486e3eb6e38bf64c085972581c"
    sha256 cellar: :any,                 arm64_sequoia: "437731ea195f65f9ef7806349db0b2efa14dd7b8adca245ec174ae9f020ca3e7"
    sha256 cellar: :any,                 arm64_sonoma:  "42427e3423799813978f5b65153f59e0942c2302945073403189ec1ae0fc05df"
    sha256 cellar: :any,                 sonoma:        "a9b92c8c50ae1fedef959c93430b2d69968cca1e0d8ba6bd73966ae39585dd9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00e37cba083d79910f84213200d9434c2b7228b5e3846749683f09a897fede5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8431a7c9a3d2263327b3c4856b93d68d68779fc1d49787231356e3bc5cf6f913"
  end

  depends_on "cmake" => :build

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