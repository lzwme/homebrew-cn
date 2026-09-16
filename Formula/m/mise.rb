class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.9.tar.gz"
  sha256 "96b461a471c9f35985611352b9d2c40cd7e66cc52496b1ad9bb64712fec677b2"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e295f0febed32a06be5c7f14f6a06932233946ae73d2e07fdaa7e9c3fcb76e94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4363173aa32a81a06d7209c3433067203dc7d7161be3d1f7df6e2fb286b44dd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "920ef466c7bdd37794396bca97a3c36a91b285ce0e6f179bca21b60f23f0a22c"
    sha256 cellar: :any,                 arm64_linux:       "e260b7242129c47a46a1e351ec6fc84a76132e01fdb1daccb03ed18a60fd5057"
    sha256 cellar: :any,                 x86_64_linux:      "6760f9a27e7cd9579e4fcf8f930a383570416e99cef383a54c740a6d4aa4eeba"
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