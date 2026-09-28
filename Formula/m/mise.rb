class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.15.tar.gz"
  sha256 "432d6e815bf1cd84a86ddbe6311db0bbae50d9228f3e6b2e9ae8588a69386e2e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93e83f1fe4494e1e6d5bbb6281ead6ea5c8665f115bc8925f1d049ab5b6e539e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6d7dfc783a69df1daace4a0ccd53a63bb9bae5b16a58d4895f7804923698988"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8cb9d5b821f64fa6e1af837399fac88eb8fdc0690b193293432d55c7c606579"
    sha256 cellar: :any,                 arm64_linux:       "b01e09f58e6f2290eb31ad0bc494616f9abc196d38e627c92798346873ff2a37"
    sha256 cellar: :any,                 x86_64_linux:      "98129ab8d2b108fee9bc31dd59b3313a9cd8cb07bf5edd35498f2c5f47cdfbe1"
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