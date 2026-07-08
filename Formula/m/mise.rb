class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.2.tar.gz"
  sha256 "6b26478395491f23c307cb82bc3748847ee6e635abdb3dc2f256e7874389b655"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40b82633d97b544961dcde8350221138f6ab16d31a7ba4983e70f10cb1ce48f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1464fd439d194aee476994d52d2c2e34a0204c22c2dce8f08b8499a4d7537594"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e0e5e543e34a70e862a6fb4400d0e7b4b4304284bae5c07ca67c7b7fc9ce986"
    sha256 cellar: :any_skip_relocation, sonoma:        "a98c86c65df3fdc2575864a094f95a69cea9fca0f34cfcd923ea133f23f62b2f"
    sha256 cellar: :any,                 arm64_linux:   "261bf6e7d2a201019200028468850c042621c602a102e36d798282c1882e5f85"
    sha256 cellar: :any,                 x86_64_linux:  "e72c2dcc5e691146d205f75bae4b1b031bb0db4efc043fd4f782c6253b5f78a5"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end