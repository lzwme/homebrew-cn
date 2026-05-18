class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.11.tar.gz"
  sha256 "c0b07d92c7ae95c312cf83f23b191ea4b94972d4091888d2b59b56e151fe2a2a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "580ca82a035266ccc202c4c1b97c6780ac2364f5abdf1996218e73f17503aebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7645de23a5736dda2240f95ae68a95a69d700fa0def022325dc9cf46b2313d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aec83efc0295e6df1a8996630e0bdc6e4b5b39abc0dec2074d5506b0078c2fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f529491d64a2053f03f477db31f26cd82463623ec7ceb46cfd4f930f150ea56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47ff99c6338fc3d98cbe2ed6ec75b0ecc087afe429d23fd29d6b06926904b8e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83c06f84f312374b0917ed6f778e96e4eacb515a8a9bb6019d1e96efc882663f"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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