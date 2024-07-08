class Sophus < Formula
  desc "C++ implementation of Lie Groups using Eigen"
  homepage "https:github.comstrasdatSophus"
  url "https:github.comstrasdatSophusarchiverefstags1.24.6.tar.gz"
  sha256 "3f3098bdac2c74d42a921dbfb0e5e4b23601739e35a1c1236c2807c399da960c"
  license "MIT"
  version_scheme 1
  head "https:github.comstrasdatSophus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee9bcc65b3d55a8d993a9912b411a746943dab25894e97de5f821e8192396a3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee9bcc65b3d55a8d993a9912b411a746943dab25894e97de5f821e8192396a3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee9bcc65b3d55a8d993a9912b411a746943dab25894e97de5f821e8192396a3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee9bcc65b3d55a8d993a9912b411a746943dab25894e97de5f821e8192396a3c"
    sha256 cellar: :any_skip_relocation, ventura:        "ee9bcc65b3d55a8d993a9912b411a746943dab25894e97de5f821e8192396a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "ee9bcc65b3d55a8d993a9912b411a746943dab25894e97de5f821e8192396a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c57213d298fbbdccb8ca68f7141091c853357ccfc9a67590e4c9671f6cfa72eb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "fmt"

  fails_with gcc: "5" # C++17 (ceres-solver dependency)

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SOPHUS_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare"examples").install "exampleshello_so3.cpp"
  end

  test do
    cp pkgshare"exampleshello_so3.cpp", testpath
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(HelloSO3)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(Sophus REQUIRED)
      add_executable(HelloSO3 hello_so3.cpp)
      target_link_libraries(HelloSO3 Sophus::Sophus)
    EOS

    system "cmake", "-S", ".", "-B", "build", "-DSophus_DIR=#{share}Sophus"
    system "cmake", "--build", "build"
    assert_match "The rotation matrices are", shell_output(".buildHelloSO3")
  end
end