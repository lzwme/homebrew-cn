class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.21.9.tar.gz"
  sha256 "848076e5630a00e10a8be0573b029cf5e4c3b22dbb9bdfeb1ca866c8723fea32"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5a455bda10d2a835a02658227fbf62b317efd97d81c1ecd270d527d593ce8b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f1f3882f1b199cfbf10f370781fbcc0ba7cba014b1b477393323b5e58085b6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e9e5d1df3eb9d089a25692e55d10b87eef12fea9e082438cb12691a696684da"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd12b0446d38c2f7c8337af7d7b1cecfc4733bf509cb0666b0d63a6e8da36be3"
    sha256 cellar: :any_skip_relocation, ventura:       "903fe4cef0c76c89bed6db7147e1ca08d34b32e5d0097dd00fab02d49d66e0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "272fe8db79325a56def35fbe5d481fcd7643144135b8698439849f964212b98d"
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