class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.6.4.tar.xz"
  sha256 "eb7f243ffc32f18324bc7fa978d0358637e7357ca7836bec55b4eb56e9749380"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "64461f6eb110f435ae2a121ee840028290f425a78c86620947c1fc132ebdee3a"
    sha256 cellar: :any,                 arm64_ventura:  "175c4f259ccae61a3f29b0356ef98b786a197eaf8fb5c49d990635df18647723"
    sha256 cellar: :any,                 arm64_monterey: "e80c11d79e895aad5d5f95b44a67defb9ef75324c95b3a297e8e58b074e8241b"
    sha256 cellar: :any,                 arm64_big_sur:  "5246fada5bfc35263943fd4a0a7f6fd17796ef3dfdebb37c2deba85f6961df54"
    sha256 cellar: :any,                 sonoma:         "1729f25c58106ee5f567da91265054266da731be4ee48161230c125f4732fe5a"
    sha256 cellar: :any,                 ventura:        "a86596881018397b88c4d2a3d42687140ce71d7e9c1b6df9b4f7c9065e0b5b66"
    sha256 cellar: :any,                 monterey:       "fd127369d24d923510d6512a1b5aa1096fd2aee018d4688934e344c925942572"
    sha256 cellar: :any,                 big_sur:        "3139c41cbf56230baf7f078e947e25b85d1699e0825ba40c7ea3d45baeab9499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69df8b2fe4d6727fea2d5ba0b0ee91e51e19d371d42f50f37c2488118b322392"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "openblas"
  depends_on "superlu"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end