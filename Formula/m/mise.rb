class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.5.tar.gz"
  sha256 "654be1a91df059213ee6b84a7742d2980da2658813511ca9e7a92ea760ade481"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72b51a31f85d61e83c1c8836e66701d707f8fc005efff085f6606e9707b6f453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9087fc02dd1dbbcc52a6f2d643a02d8c57fbaeb713fbb8aee1e1d8fca68778ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc0723fdddb961557ed03c09fd0399af7f072911c52d0a7b02925ee75b6afe44"
    sha256 cellar: :any_skip_relocation, sonoma:        "161a8ed7dd1828ff02aa2781af0f12c7908183ad5c34653e6a5d16717c67b446"
    sha256 cellar: :any_skip_relocation, ventura:       "f49a9ec148ad455ea2643fde5b06c0db25416f5c9a56f0c2e36c04c74aa2f395"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80f89403cd3d52b3335fb62fac7ac0cdcd81d1374c8dd1c9b11a73b43b8b210d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d971e4128adb7a94e23195e14048d6a9a74f94a7372e13b46a2b0841aa03d675"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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