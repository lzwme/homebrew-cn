class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://ghfast.top/https://github.com/tontinton/maki/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "4c1d4bfcf0e26a6006143dab7c12b5567467d856d67f3ae7fa4244913e029a06"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df6296ef1a53cecc14679554e16bcad6bff2eaff12d10ace01cbab15a29a0c01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba6165049c0d3b03abcb0d5aba2299cbd948c4dccd9c5f41ff2f4f980cbbd186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d462df32e832d7e837a3a54b0c29a219f651b3bfdd58cb96056903e66b944b61"
    sha256 cellar: :any,                 arm64_linux:       "8a05dc8317ad7b3b8373c6c94786d64dbb270be834d2c83b258c102eaf490eaf"
    sha256 cellar: :any,                 x86_64_linux:      "fd62e0da7a03e77a9e216c193ed15d8d408c0e6657129ce4de4da548c1a6de7b"
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