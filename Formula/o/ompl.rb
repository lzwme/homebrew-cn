class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://ghproxy.com/https://github.com/ompl/ompl/archive/refs/tags/1.6.0.tar.gz"
  sha256 "f03daa95d2bbf1c21e91a38786242c245f4740f16aa9e9adbf7c7e0236e3c625"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a09917c91429a3f0617e5b556e114a0e55e927467dbea407a1214ca230f95479"
    sha256 cellar: :any,                 arm64_ventura:  "b359522cb2aa7364331493dbb63c0f155e1f3788861577cdbe78d40b0fd619aa"
    sha256 cellar: :any,                 arm64_monterey: "863f2322e9db3e3f065b5d102ba0c0fa68c45f7be97ecacf07335e55a2882139"
    sha256 cellar: :any,                 sonoma:         "fcc8806e0fffebb8407290128dcc55cea76171f55a567bac566e3ac6006b5913"
    sha256 cellar: :any,                 ventura:        "e688f03ca6de7cb397c1fe96ad4e37a4eaa365fb9d4322b71205b674a92da3a3"
    sha256 cellar: :any,                 monterey:       "cd8be6859d0105df8c8ee2d6ff87653ea034c4e07470a4c5d85432678ba54f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51141a585e759f13151d135f15098c17753898798a16d327ab0246395c15f637"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "ode"

  def install
    args = std_cmake_args + %w[
      -DOMPL_REGISTRATION=OFF
      -DOMPL_BUILD_DEMOS=OFF
      -DOMPL_BUILD_TESTS=OFF
      -DOMPL_BUILD_PYBINDINGS=OFF
      -DOMPL_BUILD_PYTESTS=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_spot=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Triangle=ON
    ]
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}/ompl-#{version.major_minor}", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end