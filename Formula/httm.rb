class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.26.8.tar.gz"
  sha256 "ba391b2aacf912148fa92af505afa9f5fab53e362687d6de17b5082c5e5d1f73"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41b01082fdf564c032c7dc6bcfa15fcb8ecab2fd04edaa2ee40cac087cf2ae87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "672b5d92db23ca39d00e8fdecfc344cbc71b91d2e129492898d35872bb416f55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4892051f858891168f5ad10bb5a0f5d8f79dce0852bd4b46f64da8620d86ff12"
    sha256 cellar: :any_skip_relocation, ventura:        "0b51792002dbc806d884f367bd4fcd374fe2cd8e5506b406bc7ebc7eb6846b13"
    sha256 cellar: :any_skip_relocation, monterey:       "6c9ea110e49e5084af2879dc03dc95d1e1430132f40a217256d6d0eb10a85351"
    sha256 cellar: :any_skip_relocation, big_sur:        "4950c2e2bc2e6e0559a029b9e3c9421232ac2eba3ccb923a67147280caa5ce6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b3d89657fa0a91f23c0fa79c6cbfcf8e0e722ff8ec6ad7ec52282f6a5c0ec1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end