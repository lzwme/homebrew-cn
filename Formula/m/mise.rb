class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.19.tar.gz"
  sha256 "01e180b643c462180a408f8715f52e57bebea206881650ab3f3f93e6e09ef4a1"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e72e19397433c32be6efc47157f57f0a3070bd2bffec39e1b79013d0cd50a35a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "789af4acc87e75485ffffd12a498397ae6a2cfaa6f539a936359c35c2be6b5e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be6d3fa3fe85354c2cec278f560aba372c7bc2205eb3edabce750535c15cf001"
    sha256 cellar: :any,                 arm64_linux:       "c926ba1fd096d35b9add3dd4b449ec96985f6cfde13b5aa29c84aa3c4b2c38b7"
    sha256 cellar: :any,                 x86_64_linux:      "465f37d53d5f610f1799684e09a43636bdc1576b9540aa3fac2ac233b1a26244"
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