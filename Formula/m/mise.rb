class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.17.tar.gz"
  sha256 "d671f0b58a289b19ae6b48e8a416e2b9946ea863bf1b8192dabcac20122a2d9e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f451d01401f4678e8553c64fad07f77e673ef53aa6ca965740ba4c6dc154e16d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f445670d05c0f7125669a663ef14fd52cbd97fa57111813648f6d48224aa6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18d450c985541849e8769ae5865d8ca0ad1436e0a081abc925fb7b71f64e3523"
    sha256 cellar: :any_skip_relocation, sonoma:        "4059900487f1d8e9ba219f78be41c89937fc66b32068e8a94dd0112c7c7d1aac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b21541aa41be12ef35a6eb1886d362c5ff298828640d2c461912679f1250a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ea3e045f6e53f89be7916a27301a713f55ab4d872683416ce18ccf68b2c241e"
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