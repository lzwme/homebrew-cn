class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "8693fae65a32e7066ee11cb7bf29b2c4c3531586c704e22a83d15a1599fda248"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be661891d7a8ed4313deb063739c81b830e12f1e1836a761049e962768f201c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a507f8a1d7d5e1cb68f02be7c6b49f7aefa5f810301a9ae140dc2f633871525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "263d0e7544e55db046751afa731b9091243a84e0b1d590c3537e3f9714ed1220"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a351dcb4a355d3f622e4ae3976558c81a43bac4262bf3588350e5f464f79a1b"
    sha256 cellar: :any,                 arm64_linux:   "0876c556264dafb4279b8d15b4fad0460557d54e96eb450584068057403a00e7"
    sha256 cellar: :any,                 x86_64_linux:  "07df1890bc15f71d23a293f4011042fd1aa9d1ab542ff74d8a31d2350bb55203"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end