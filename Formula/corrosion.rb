class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://ghproxy.com/https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.tar.gz"
  sha256 "77e2f5beed28a0417a887e79094d7b677ccd0b6c98861d147a5731a3d682ddec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "030ad92c245b54b8655a4db14923c9684935885189b757d4b35a8b4272ca2a45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5c081899f4bce40a6201b933c0916583dd35cd77066e1c76473e412d2eabf54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a49c2ea8e9b469b02b6219a2ceb7cc9a2be8576a8999d07638855eb1638e0fa4"
    sha256 cellar: :any_skip_relocation, ventura:        "1e3bad176e0c01e8df8bd20bf8348d161dca51e9f6cf02d2752c646566e19737"
    sha256 cellar: :any_skip_relocation, monterey:       "7656a2cbf6fbe259ccb9d9f8125ac2178c3d3a12a41e4eb847cb1d6a71e3bd20"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a33068fd0b46f5b76b20101420d2595b9b6d24b9ec2010bd354ffd47ae33875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd5f71d64afb545940d206d1aae6ea3ac86b75223477803929fd316806fd0a8"
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