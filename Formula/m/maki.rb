class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://ghfast.top/https://github.com/tontinton/maki/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "4d2a3116625978fd82d9edf5f8309573c00564d138d6752f977245f8ea7d148b"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f869eefb7a6e05644443f9776a1b4a85653456ed72d153de63e5f346da0e2707"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bdd8fe579cb73788fba45f949c5e0b80ad17b5cd144e957120ece0a21cc5c02a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1e6688c8837808bd58d997632573f0821f36cb474a147dcf44d9092bef8b7cb"
    sha256 cellar: :any,                 arm64_linux:       "ff3830cc2140f81f6e0cd68a77aa7250012af5f8997950f3735d1fe6126833e6"
    sha256 cellar: :any,                 x86_64_linux:      "65ad56c007ad3317e16f1830d059fb14e05512bdff98f524501fcf46daac58e2"
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