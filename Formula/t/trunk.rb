class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.21.3.tar.gz"
  sha256 "634ff0086304b164b90e9d55699199c90f5b69a7793c8f36aeb4da7fa81bd4d4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c05ecf115102091e538d89f83965d6e4028867fdf7cb513e3fa94b0fba7abc56"
    sha256 cellar: :any,                 arm64_sonoma:  "acea7cd315bb9ff854c4c5322dbd5d8f83e80f5bbda0ba5490422b0a39c1964f"
    sha256 cellar: :any,                 arm64_ventura: "b380779e4e23b8cefbdd43d89db23601dfdfc19e251d90584bd7e4a3227a269a"
    sha256 cellar: :any,                 sonoma:        "2c6a9c7f49aace56f0214601ecc45d5fc8154ce18a5993668aa5d8b94e4e17bb"
    sha256 cellar: :any,                 ventura:       "89b256ac6656b9e2f405176c14a8f3078b45e9878acead27d561abadfe4eab6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459b89ff561bb5ecd03eba86edc5982fb632b719cfd0ee56c4e5aa0c327b6076"
  end

  depends_on "pkg-config" => :build
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