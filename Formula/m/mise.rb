class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.7.tar.gz"
  sha256 "a6bf17d3d023461ef8892c57b8942cdf92dcc204817e9e39c6af01bb1c8ada49"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48f9ee956048d69901998f64f4678cd9b3d38fb3c6b16716fe855057166c9168"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8028a8c5ca48b128baaf930ee675a64ae398dce6bc9bffa3e705ea89f8b450be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6896cfda5558bb23eee98226d34c38ea930315fa769028f397b210d0d1d8d4c"
    sha256 cellar: :any,                 arm64_linux:       "ae37d363995d3ba8fc90b7470cbafe8baa230e2b2f1b40d4f440cc76e0dd392f"
    sha256 cellar: :any,                 x86_64_linux:      "78db4ac8c7329e187db3e8f36865e8cd346153b98bbde0bf6742d327c0694ccc"
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