class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.4.tar.gz"
  sha256 "745a677234f0482e9ee6abaf897e220a2d8375f8a7868e8fb50833dedcb0c5fc"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70f2c37e8e02dcb73f913f3a32f1c1d0c76c75dffdcc15fc4ddb61ff581f6fd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21bf65d10920badadcf4f0f30a835acc0abf0956f694cf3593082cf6f7036e0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc12dc1d4b1d5ebe36ef05031d6c7efa1b732b1d2e6f9f3451c9ba9ce4408c85"
    sha256 cellar: :any,                 arm64_linux:   "9e12cf45f24cc8aeafdbb9b62279e818c5a1b8c05a3058897433cc7199733cd9"
    sha256 cellar: :any,                 x86_64_linux:  "28d4ad0054d357a4e1659e55846f79eea71eae3852d247a07ae4f34f4a247348"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

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