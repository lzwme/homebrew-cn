class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.21.12.tar.gz"
  sha256 "8b4f6be421c9aec08b327e79e50fad8015dc6f56fc0c856d9320bdf97df0bc05"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c2af54483256c650ac8778f608124738357bf8dc26237bd8f3faf27a94cefa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be120b59376be127905f7e42482017c76e433a0343c769990200059e9d6aa517"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6397a7c138d1fa72c0a6e61e49a608adcc0f031edad07f3cbc81456b0f9a6337"
    sha256 cellar: :any_skip_relocation, sonoma:        "079dc6afcc308861e054c6e3ed7c685113aed53089358847e9843de449993b5a"
    sha256 cellar: :any_skip_relocation, ventura:       "36f28c2820a1bb7a5b1da6e9a55a807d4c392d763a4dbcfa31a3fb7a22e5a141"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fec4fd912c2976e31a39bfbfc716a4292b2f874755378b983881f02785b717b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34c073754e857b14098d4d57565096e3a8bbe467951a27f3bbc86e42153135bc"
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