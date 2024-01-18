class Corrosion < Formula
  desc "Easy Rust and CC++ Integration"
  homepage "https:github.comcorrosion-rscorrosion"
  url "https:github.comcorrosion-rscorrosionarchiverefstagsv0.4.6.tar.gz"
  sha256 "5be7fcaec75a9285616b7686391e01ccf39a7e3f769e672af9fa3d34ac35a8d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3be254b0f6b4d0e00fe26444bfb85ba0187d93d7fc8e5e2c012e02049946485"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcb17f90dfca87347a3db734d88dfae279720ec032f14f660d53ddba7835ab95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c3f35976fd64d1f5e9a39c6158d67083a3351736921719ee3f5bc4a46f1e5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8bdfd7ee0098f6ec0b6cd6d794d898da9c82b1b6908784a499b2c969d90ea8c"
    sha256 cellar: :any_skip_relocation, ventura:        "84101c0a20b346295dfefe741b41e8d0f4a26d02e9511e64af52f402eb46f82e"
    sha256 cellar: :any_skip_relocation, monterey:       "701f8c581e2a42cf7ca15eed4aff8ab2512b2b453f01d23726d3fdf0c6388c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "697d38362044418acb45306f32af0e0c22d95ff3601f9ccbb14be4ed0c2892e4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare"testrust2cpprust2cpp.", testpath
    inreplace "CMakeLists.txt", "include(....test_header.cmake)", "find_package(Corrosion REQUIRED)"
    system "cmake", "."
    system "cmake", "--build", "."
    assert_match "Hello, Cpp! I'm Rust!", shell_output(".cpp-exe")
  end
end