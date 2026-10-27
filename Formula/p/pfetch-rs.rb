class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://ghfast.top/https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "976aedbe1baee9e9c398811900d37e6a42c1fe74332ea7c0f7c7340f301074d7"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c060f3f0456cc683952a41900e86edafcbebacfccaa1fd23535a0a397863521"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06c934242b3ed0703b157abdde551867e7589186f1b4254daf23e60d532ca31b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edaa23ffe2914d862ee1d8b28db956a1845865884583e57855a0c7b57e3e1363"
    sha256 cellar: :any,                 arm64_linux:       "eaaaada857230fc8b10d1e1ed92f5fb57fe7ff6ebc380570f3b95a985eb9961a"
    sha256 cellar: :any,                 x86_64_linux:      "5763086a83c594629f80acf79eb89e2cca40a95a91380ea9c7b89ac3570ac91f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end