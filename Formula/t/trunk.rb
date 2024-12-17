class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.21.5.tar.gz"
  sha256 "479a26d64458600197a853cd3ad99b247c4d319a07b417c022ea626681867fa0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ae03eb28cd8d07ee2b4396268ca9c23d4ab4dc204363a711366a39db178d30a"
    sha256 cellar: :any,                 arm64_sonoma:  "56cc319c413865489c7a3cbc5ca15786ce092f4925d9efe0595a9e6780fd492a"
    sha256 cellar: :any,                 arm64_ventura: "46df1fbee319ee27b4803377163950c811cbd43f5704e61d3152442f6aded3c4"
    sha256 cellar: :any,                 sonoma:        "f66d5fdb5d2d9b587f9028e355fe01af3a672684a9851f10f59a84ec893e3e25"
    sha256 cellar: :any,                 ventura:       "5bdfe812119f3ce55ccd8a2a74021c1c952ddf07a7d03eccfdbca4c250632e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb8524ffc3c2e67f194978028e0ee03de91564e2410c0635597614e5f983ef2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["TRUNK_CONFIG"] = testpath"Trunk.toml"
    (testpath"Trunk.toml").write <<~TOML
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    TOML

    assert_match "Configuration {\n", shell_output("#{bin}trunk config show")

    assert_match version.to_s, shell_output("#{bin}trunk --version")
  end
end