class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.0.tar.gz"
  sha256 "69ad27960361895abd19cdbfcc431a58230b64fb64db9b34d9ab9d6f12dd6b7f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e93fa48c7161e4451c2249d79d1b72e3639cb3407292d40e6f3c90abd190b20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b763a761f8615f049e55e97ceabeef2e5d7284e27d711089090f4bd46d027ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1a8b9a63b30941493a6061604155db2ec96950ea26f0888d9fa562e7f22a36e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e96219f50c1b0f6ba5ff5ed2daea27ccdc915077641a9c4979dfd6797232f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00140f7e8b59fc71c6a0b7a1b7d7219cd8888edd91805587f8fcbe58ae4ae67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1a73fa9b48c0fbc0419d6df19fa208704bb0784a87768a28b2603372235aaa"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
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