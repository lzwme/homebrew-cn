class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.21.2.tar.gz"
  sha256 "de7180e8602bf43adfcee761c7c635d44aa5708876ec8f1c1c41d10f505d682d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7a93782623889cac425129d02746b2083f0df4c7fd75d063dfa0f92ffb468d7"
    sha256 cellar: :any,                 arm64_sonoma:  "e6fee5cdd2a95b1c6e9ccd1ee103b28ff71093ecee54c40fa7a62cd21a9da332"
    sha256 cellar: :any,                 arm64_ventura: "8579266ffae9ba6083057e1291f19d9e5d0baab49e963f1e63e9320561c6732b"
    sha256 cellar: :any,                 sonoma:        "60c43f9f4f43c04b2e94761ab994c5ca52f837944c40ec3b3ecb870e22181d51"
    sha256 cellar: :any,                 ventura:       "f04352ff28ec0a7160f93e0717e44c9f1a2335d1dec0e74ca9b1a575221fc358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701f17ca1d2aadcd8cf35736d42cb4293692e156051f14c4efdc37869b19110d"
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