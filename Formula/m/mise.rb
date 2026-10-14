class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.9.tar.gz"
  sha256 "821bed78c85cea6f0391a10cb0f71bb2126228acdf29b4766a8b342089276203"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd124ad5ee3c6de8f230704666099c971725bb32708f7e0d56ef3ebbed17ddb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef5314dccb53f6aba773923844a3076f3caefb6cb1b10a7ccf689ae39fa2bf77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6e00c1c005e7ad3e51cd8ca976adf8d6e07f691d4596c61fef011ced6c5e332"
    sha256 cellar: :any,                 arm64_linux:       "6d82777d27b998cc6de761edd9b318972eb1596a78ef1fcbaea22e28e22a1e40"
    sha256 cellar: :any,                 x86_64_linux:      "d00a8eb0c1fab3d26a0afbcba95efc62946444d2315645d8e10a49b434c0c4bd"
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