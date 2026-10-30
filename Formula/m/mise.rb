class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.23.tar.gz"
  sha256 "990f14fd3fd0f6a94a12c9f083dcfa8e7f3265391b7525598c933343ea949d5c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7972239c72ceb369f80782ec71e938a02e9f5e5ca1795908c2c4e632c6e20916"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0617651c317872e02828845889198ccfe75301df6ab9dd548c6339585af9c4f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50139bcee91eff2af6cebb2c29eca193bff78c45be60d1a5f5c5edef1c6c2625"
    sha256 cellar: :any,                 arm64_linux:       "845dfeee6d73729f66ae7c474ed0564e2d1f0b403a0bee2449e7de6b2e7dd19b"
    sha256 cellar: :any,                 x86_64_linux:      "675838d1245c33f1e8afa8f516b976df10abd9c83dc1a6c0b02fbee11869c3a9"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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