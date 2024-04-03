class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https:ompl.kavrakilab.org"
  url "https:github.comomplomplarchiverefstags1.6.0.tar.gz"
  sha256 "f03daa95d2bbf1c21e91a38786242c245f4740f16aa9e9adbf7c7e0236e3c625"
  license "BSD-3-Clause"
  revision 6
  head "https:github.comomplompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https:ompl.kavrakilab.orgdownload.html"
    regex(%r{href=.*?omplomplarchivev?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "865e814b18dd4d8746be5666ec8e3fc7b983a0a2e959a02a061f80c2918548e8"
    sha256 cellar: :any,                 arm64_ventura:  "d7487f8f7dbfcbc224893e872cbb8cc2d4035264e7041031a5994287fad8ce8a"
    sha256 cellar: :any,                 arm64_monterey: "dc1b9aad0e9a3b1e1ebdeb9f2a6b458ef3b54d07343c199480c61bd926c9c38a"
    sha256 cellar: :any,                 sonoma:         "bfb3520a662f1729a996aeff7f189492b9186595b8f76f8a2fab73245032cf9d"
    sha256 cellar: :any,                 ventura:        "a9e2ca42a933247fda282df198d45b4fd6835ed5a94065e2d37d896fea23b0be"
    sha256 cellar: :any,                 monterey:       "1323e356e346af7f554a3f6bf641aa48f62a0f89142460e164b0982689184dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2baaf026798bba1f2e07fc2244602b39e4371f4cc39f05f45af8daa00e9c8668"
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
    (testpath"test.cpp").write <<~EOS
      #include <omplbasespacesRealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}ompl-#{version.major_minor}", "-L#{lib}", "-lompl", "-o", "test"
    system ".test"
  end
end