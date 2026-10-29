class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://ghfast.top/https://github.com/tontinton/maki/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "4d2a3116625978fd82d9edf5f8309573c00564d138d6752f977245f8ea7d148b"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9264d3e5721a895fadd224ea20cf29112663befd4ead9b0fe3d45504af1233e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f64373418dd5932bd94eb225b64508d675ca44bd03b17d33e5e21d5f6574e34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2a85946331a2071c4e42ad8539d7496daaa5d5eb6de484959af2449ae6aa53e"
    sha256 cellar: :any,                 arm64_linux:       "e4d08b0a54e6756c9e2cdba6bdbf4cbde73ff74b8bafebf36a14fa1d1450c769"
    sha256 cellar: :any,                 x86_64_linux:      "2973a2486693d17155fc472b0e264b6bdf7963bf210a27dc3ff5f367ffcf0842"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/maki --version")

    (testpath/"test.rs").write <<~RUST
      fn greet(name: &str) -> String {
          format!("hi {name}")
      }
    RUST
    assert_match "greet(name: &str) -> String [1-3]", shell_output("#{bin}/maki index test.rs")
  end
end