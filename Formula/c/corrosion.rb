class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://ghproxy.com/https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "32e91eb2eac16f1c48c88f2c918ccf82a2c4fc787f872654e658825a0ba48a29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa5d051e57ba924f79480c88955f538985c243fc90ad305242ea3773306fcd6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74a7ae5ffcd696388cf27bc9d7517e7082062df588d22267adfe3304edf6ef45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dccce1bbe6bb8e153c81e3fc9304c99c201b2fa60f27bac2e30b3d8d9d3d4e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5223d67bd1aceb383a21d6806a9a8dc1f1d30182dd8bbd1fb89c63403780a3ce"
    sha256 cellar: :any_skip_relocation, ventura:        "0b344a0c09ff746eff244cbc9f675edbe12866a0776efeb56388ed03286ef553"
    sha256 cellar: :any_skip_relocation, monterey:       "851f8b467c253993bb4640d071913645838ced9b4a21b471114fa67a0c670c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "273379ce2d93681e9fa529fef93cff218b2e20d261d16c71c2cbd0b914b346db"
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