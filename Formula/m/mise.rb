class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.13.tar.gz"
  sha256 "5e3cfaeb4cfaba656fb7532759e8a268da965a76646869ca2215465a4e99aa22"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f45aeed4db172596c2ec1d41dcde2e1ef66482051cee11e5c4080e7146fc258b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a433ce7be4f3d7602636dfdfffbca5bcb93c635fdfadea12497e122197fa2596"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "564b5f6d72ed23aeefafbf955de1b593c30add2f114f08e30a98eac1b8e92e13"
    sha256 cellar: :any,                 arm64_linux:       "74cc438245055910aa4d5010584bde0a718af41ff08ac3321205d8adc014a29d"
    sha256 cellar: :any,                 x86_64_linux:      "a423c3b85ecdbce152768f770cbb007fd0a1f387f82a5189ee8bbe10dbabbe7a"
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