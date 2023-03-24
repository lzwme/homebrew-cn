class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://ghproxy.com/https://github.com/rune-rs/rune/archive/refs/tags/0.12.2.tar.gz"
  sha256 "2c2724680566347522e46cd53b7db08c2eebdc7d9250e60501466592d5fbba55"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63c12143c84dda31eabcd16b75f21683e9f81cf1d17eb14100e15c17b5b38320"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "955c3b1d2d8f3703a6b1682aae0100ca7bc0f6e2f850a9f7be2286738a8c8de5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30acc00635900684c0276974e017c315972e21b54435966d82a1e50c66ac7fe8"
    sha256 cellar: :any_skip_relocation, ventura:        "d94935f6c13d0bb2382616f5f78fcb23071d9fe56bc732931c163056e93a9fd5"
    sha256 cellar: :any_skip_relocation, monterey:       "0ef01a496469f9e0c0c10e54d3f3398b40f810c8d06fe535d2b02c6967716040"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c6bc6f8ee9d2acac73e968c81d3df98200eb3ea40360855ed9e57c3e46dced2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afebe32639d761c9e67031cab51201029fdd38dd0a15701dedeef32712417ecb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rune-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/rune-languageserver")
  end

  test do
    (testpath/"hello.rn").write <<~EOS
      pub fn main() {
        println!("Hello, world!");
      }
    EOS
    assert_match "Hello, world!", shell_output("#{bin/"rune"} run #{testpath/"hello.rn"}").strip
  end
end