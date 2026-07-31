class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.17.tar.gz"
  sha256 "7b48e01bf843face74630dc8f09593a61b171ab5ab6dc56e574d0d5be11590d5"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cce6e1cbe95306b62f4b82bfe981353010b21ff7ab6805af6f6920901b15681c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c63ce6a765028dec915715b720b26d3f1f47883475e6f0750cf4c1df7be2fd08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0568c2e1d7bfbdacbba5aaccfcb48f664d990168529abbfddee7ad1432b65f5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "49af461d71ea513959975fb58d6cd3936b2a61dc32509b03d47d08398052c9b9"
    sha256 cellar: :any,                 arm64_linux:   "6cd4198924234601f97c4118ef1510d58b4c0b46a109d3a1b64b61429cc08703"
    sha256 cellar: :any,                 x86_64_linux:  "6d6ca445cb4f0540f59d66af417f405b2663234d756709a6c807bb272b160bea"
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