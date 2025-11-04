class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://ghfast.top/https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.21.tar.gz"
  sha256 "0c3d53e211a9c880a8466839235f218591f2ecefce62bbf04afc8adfdb9c1e65"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8d91d27cbecf9391a768e7f836d2c52c1f41d27f1b803b2e14e26f2c5102250"
    sha256 cellar: :any,                 arm64_sequoia: "14660827a5a061626290a48376a9e32e884d49b6942646e5f3826f004a6a33bc"
    sha256 cellar: :any,                 arm64_sonoma:  "0965a1423b67faec11f00c5c526fb66bf9f4a99b8ef6bce1ed9f6ad8ad28923c"
    sha256 cellar: :any,                 sonoma:        "06a5cd05f3813c4f32164df5c69b88144d9753a3f4e38a63e5a73d7ae4213764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3e272d408c9e901bedb3a22f1e3f481c58ebd9c81643091b7322c1b0a1886d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32450888726055263d963389fd718468f4cc9fe445bf5488be288e16a6b4a96e"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "mcp-toolbox", because: "both install `toolbox` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end