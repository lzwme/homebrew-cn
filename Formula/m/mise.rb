class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.6.tar.gz"
  sha256 "442acc371fc49dd08558f787d5ac3e170eb4ea1fcae6ab12b81cc3ff3120ffdb"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8a285472bb198fea8ce7627fccfd0bc8fff568a114f0de93282091d41c1aded"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d0caf26d312a13866ac680e1afa53819d290739d7526bc887cb76f137eab48b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41db8bdeb7f827fbfa2b6b7b832592b9b891e51bc91ef2f8032c9e1ba72ccd3b"
    sha256 cellar: :any,                 arm64_linux:       "d35cc3ee1d08fb99d7dbf47d6ece6b652facdd62fcd5ef6876449620d7cdd8f1"
    sha256 cellar: :any,                 x86_64_linux:      "42ed2aaa7d9dcf346e9d44ec1932e6ed72e68bf55f9a4b6fc80729523ab12f63"
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