class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.21.0.tar.gz"
  sha256 "648ff0f89fe461d4977f389e38c5780cd79762ff5caf81e610c37461ea4801d9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d58d1521310372e7e7b8b5eafa628c0a5b85b7c4fe200615ed9a296b3f673b1"
    sha256 cellar: :any,                 arm64_sonoma:  "d2b3daa89791ee212c7bcd7a6dd7988ba0fb62c57d98f314e09e5ef9ef4b011f"
    sha256 cellar: :any,                 arm64_ventura: "5671d501ec6e13b4e41fb8397089f347f335930bdf073ceb407a513499529617"
    sha256 cellar: :any,                 sonoma:        "39e76eed3e4f311e1b98731c9ac486e0fd10ede505fe1dc57f5ccffe95ecf5b3"
    sha256 cellar: :any,                 ventura:       "dfe91a68b3d9f853fe96c83340550a3d67ab04f27dc91fbc8566ec14c60a4ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1989dedcf63ca26f23b1830b86cae42325d1e482369b6c0cc5477780b4813beb"
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
    (testpath"Trunk.toml").write <<~EOS
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    EOS

    assert_match "Configuration {\n", shell_output("#{bin}trunk config show")

    assert_match version.to_s, shell_output("#{bin}trunk --version")
  end
end