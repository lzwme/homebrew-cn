class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://ghproxy.com/https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "939fff7fb34e8169b54e2c48b56d38aed8e616a83265ceaaeffdc3bbd26d3865"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89023644bfe2bcc2df750d1af95a41f1de8afe2d621bfaa9cca1d246255ca3a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d8c36e30c6fd281880022e2a1ad3c4b9adb2914e250304e5869d998ce99fdf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "833be31c9ac5172fb8bf2480f4a27c52a4c261ed449a92f48fd97170a4baa814"
    sha256 cellar: :any_skip_relocation, ventura:        "976b124b9d62e21ea453b805430981dfbf22ec0ecfdd62b15aa5133320804101"
    sha256 cellar: :any_skip_relocation, monterey:       "e1d783eddf9106bd486d8621584d7d7d4ce9e2f129b6dee05fbf01d852750854"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe44cd788828a91de56d32c7b6572c6a8962ee93d47087e6aafed5474427984c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93ab861fe2e2a8eca12cfc4a9a1dd80f5f8ece01b08bff2e981473ae5b5e5c65"
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
    cp_r pkgshare/"test/rust2cpp/rust2cpp/.", testpath
    inreplace "CMakeLists.txt", "include(../../test_header.cmake)", "find_package(Corrosion REQUIRED)"
    system "cmake", "."
    system "cmake", "--build", "."
    assert_match "Hello, Cpp! I'm Rust!", shell_output("./cpp-exe")
  end
end