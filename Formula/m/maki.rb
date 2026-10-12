class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://ghfast.top/https://github.com/tontinton/maki/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "6e1b7228c57b2c63a70b8396fb4c864985786c671b54227557c860e197107d30"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02a8db419a43d53c6d524ebe538f02437f81a2a1a3b2902763f9ea2c6640a288"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d06de76eb13f2fb84a0e86c549cf7a99d2dfcb8435acefc0fdc5feec9b99f775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "444b28c93401f645ebf42cffb58ce46ce7cb88513daabbc2f049df3e4b0116a6"
    sha256 cellar: :any,                 arm64_linux:       "7213b633233964e88b4263386c02d3c9987e81d19c4a63e9904c9c98a5caaa99"
    sha256 cellar: :any,                 x86_64_linux:      "1e7b3e3a15b594823f6195c3caa1a028e471a96fb18c48de2f7c0caa0eaf21e1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
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