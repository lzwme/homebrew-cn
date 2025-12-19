class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.12.12.tar.gz"
  sha256 "50f3572e99b5dcd087a66aadc9e3f0a7499c26221a809ecf9a8de0bd8ab5df75"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8501821434872c6d952cd42ef2b9e9f0c38dc8d2644f414b1c8b18abb31ef203"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0055e026d05210922adb0c6eb655872f887dc1e4fc0b522ac2e0fee3a806660f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "025b6b53f0de80c12ed8152b093f84eafe0334fd2f3b99b86afcb5daf40a4e3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e231175c1862ae9d464d55d88550aab7b1bcecaf0915e4bcf49b9487a8f6190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a0cdbcef72cda84e0db16201899a0b43c526a0dac82823dab3ad5bebb86b066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04e766565fdcd8d2b0649f9c27a1a161bf8032833c5db031d95ed66e87e64efe"
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