class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.0.2.tar.gz"
  sha256 "3487775e93a0b9b04239372f7e150a1c83b46f0f6e64ff8a5f6ee00f8f510e12"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44e12bd609000d65a93460dec06901b72d8e5b98d461bd6d35e34e9596749479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6b4514db447eb5b06e0554582e9382e6e929ff702558cb5a78749e7a76b9178"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c898caeef5d011e6cfd73c602ede693d545941b4ad567e32209fa8fad167f6b0"
    sha256 cellar: :any_skip_relocation, ventura:        "3e5e9906aedd3945383b713f417c8f29a7af8875341992d318d43982ac67543f"
    sha256 cellar: :any_skip_relocation, monterey:       "be04f1cbb9ba5db62102674c17bfb3a7c203da1a7c72bfd53b46b56df45b6667"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ef6743624200bc379d43177787911fdc07b5500a171cdb9d97cb845b852aab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcf677fa1ece3d649e79d6aac6b6cea4b764544adb2bc28196f81596fa2f48f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # FIXME: Figure out why cargo doesn't respect .cargo/config.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end