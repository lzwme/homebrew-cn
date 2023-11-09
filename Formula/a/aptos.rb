class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.3.1.tar.gz"
  sha256 "de56f20f8b510118ce583a52f2cd0b978b5f5c704498d0e70dadd2a08c18e0ac"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ab737e399bb8a07b55ad2b667a71c2fc17eeb425765aa668657f070b01bc3ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c1601c80f657e0c78fc710cb2d3091a755a2919f37544f572cf9d54126640e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7fb3030412e77513056ffda8365817aadcd67b2b90eceb0f3f77c1c1b17115"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f9785d42a7f04d41c77e8ec62c84fad1534bef0061ed5b3057c14ebee9a3601"
    sha256 cellar: :any_skip_relocation, ventura:        "393fbfeeac97c1672191dffdbda0e01f4e17a24c4be8a1a9e2d55229042bd4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "cf23c5a0e29c48de13d57b6f44d788b01d6f475e77d34ef7ccd48633a7af61d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70adbf152a905de3c95e71ac349d8096b276c6d86bb06ad1b3a2a0bac9cbb8c2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
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