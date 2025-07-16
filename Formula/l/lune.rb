class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://ghfast.top/https://github.com/lune-org/lune/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "56fdb35c99878d4b703d03187455af224a6897e0e80e87119449bd61136a54f5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904f5cd1bf1307c434b0067b3732475f62671c724edb9728e69a620cb354a0f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91cc05cbe084d3ac9951465e23f2c51804378298fb0639cd044adbdb1bde2549"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1e8d3a648263fc67f118e5571d05eb5bfd50dbeffbc7207e2a69de143116425"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d4afd1f37923f3e7bdf41a33a938a690c3299f7715bcfef600591a60be67b64"
    sha256 cellar: :any_skip_relocation, ventura:       "4d35408ffd4e119981341794f21d48418a0191232c6cc5a6b2e3cd27ea01071e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad32cfcc0a21a8d8346caeac29e551a9e26eb678ea857d5500be242f57cd822b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2340f854689837770351f0e59c3a34b75205ad079cfba9b5d40b68422864126b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end