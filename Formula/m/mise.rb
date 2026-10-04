class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.1.tar.gz"
  sha256 "5057cb045a18c5f3673c25f73c3e52eb6b09b64c1bb1cb35d5fcb106942f8035"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e8ad349841b99266ef745b087143391390af0850bb467e77745d86c6ad2c6d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47408bfb4b998bc2ff8501ff2da0f528f1b0f473ef3d5b6e3c337d119fddeff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e71d0b219ef3c04db4a451e54d11c0a0c00beb7809209a09bc8d25c69afbdeda"
    sha256 cellar: :any,                 arm64_linux:       "03b07a2b631081b2903504c890a2d54d3ffc1126ef2939833c0b4f7dce66d5e2"
    sha256 cellar: :any,                 x86_64_linux:      "bca2c9f8130193778ee98dfb4251c67d7f57cc3bc2ea4b941add665daf8e58e1"
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