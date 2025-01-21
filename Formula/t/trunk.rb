class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.21.6.tar.gz"
  sha256 "2a444fa4df07d3d14e95c44ca25e467c24ee774394136a5bd6b285a26a0e6a30"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a6a4a30d397c13344480bd9dd835a190366c7031207f8e53f0441f81fb8a705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be67b94c7dadc98c8089fcb49e82ceb934f2d90338e53ecbe777ccfc7a6d02e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ec9b14ea48e4828a3cd2b11a78755e58c07561a8efd46e732e7246b57613b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "3df9cf36ed94d249e10c1794198129dbd156e445224a4bd50898b25f27797f6e"
    sha256 cellar: :any_skip_relocation, ventura:       "f106d854fd04424e17562edf6611f6a5e6da3a67822f4f328e7196d2b32ded2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f4b7c1fc1372f5d0a02144b6f2c0f973301e772c4229544de8034c30f708cfd"
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