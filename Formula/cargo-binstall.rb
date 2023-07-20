class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "33242301d03ace0dca0f4a1fe86df6fe96f20d6516bb10e95c862c4367fede15"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aaeb5adf43f7dc536a065c338947bd047a739c7960e1421bedadfaceb592908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34709a72b509cead6e4efde22a87c6465ef540756fd63c5cf2c2b80fee995455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b62203e806d133912e25ac4c2ff658f92e6e14423c0471c15b347d36652ceab0"
    sha256 cellar: :any_skip_relocation, ventura:        "7d7139e3c8e17c26a46721f54cda2c4740e2dfcf5ffb9f1ec42dfd54a128ed14"
    sha256 cellar: :any_skip_relocation, monterey:       "4ea2fc7730cf73dc74c9549365eddf1a4e94f0185ab5542cc3076854b73ea250"
    sha256 cellar: :any_skip_relocation, big_sur:        "a379834680edf99ceea624881377146552efd542672408440ca0b33de4dfc36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099b8c97a91403ce88a368a163fc7810d636bcddba26ddb257e64b4b2f9ace50"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end