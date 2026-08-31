class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.15.tar.gz"
  sha256 "b86611eab656691ce364853294027a1da5731ce2377a8bd38e50d9ce1d5cd7dd"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6fa1c856183417a3b2e558c152645cc8cad766686bab279319d27e4eb884a8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8798ce9346e9f399c22ad6485a6a1811347d5132080688a34eff13f6fe2ae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ad6a0324d435e9fb6178de17d32ecece38da49eb620b6e7e9f41b87b6fa42c7"
    sha256 cellar: :any,                 arm64_linux:   "ed29ad46b2acb7664b700e662a2a67b170f89d89417624f6f2806e84785fb0ae"
    sha256 cellar: :any,                 x86_64_linux:  "5f31b4c715637cb61cff8f7575e0f39f2b3320369a1b520e52f866d9c5396aa7"
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