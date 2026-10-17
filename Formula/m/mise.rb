class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.12.tar.gz"
  sha256 "691fc9341529f9cdd7a601e1cf29709784da6f857c71f93917fdf5f442c598d4"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20d1844ad71b1068a2cb1a00fc56499cecb6d63c666a4c24a8d668fc199121eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18993a83e770d676cde20f62043320450e6398de7ae279c4e5e6dc3fd6eb14eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bbe712306205ab408112bbdaad85b91ed2cfdcf2f330292980447fdeacbc3c26"
    sha256 cellar: :any,                 arm64_linux:       "3b66deba466e0acd8f50056fecf943cef90b542f449ea21af762855c79d079c2"
    sha256 cellar: :any,                 x86_64_linux:      "80a9c1a06e7ea5b40f9d86066a3e6ba1f773b0f15e5c786d17b4fc146fff467d"
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