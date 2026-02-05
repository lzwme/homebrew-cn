class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.3.tar.gz"
  sha256 "634a41e2c6b9b5a36956cbd0af969fbf24d91edfcd43e309af9763e9ce39f86a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee591e58437eff855750ee3be41b090f14927d1a00f1d1fd40a291db0b2e93d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9054405116107826bff8bdabb2763aecba1e35ea97ac342815fa258fe02f7b17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b732b806449902a8be305407ea5c501e45e324a862fb7fb1f7e8a48bdfc7c482"
    sha256 cellar: :any_skip_relocation, sonoma:        "722e9b562706b29b6d32d9ff049ee8759da22e832dc1e9d1743145c8218b7183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ff02efeba4ac3b8769b72e94647d150e4c35646ef7d0bbaa42df53b63a16a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c36a5cec71238804f613fd72cbad1d4970c2ae6d1fb7370db29c2610796515e"
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
    ENV["OPENSSL_NO_VENDOR"] = "1"

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