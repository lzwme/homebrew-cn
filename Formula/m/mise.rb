class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.10.tar.gz"
  sha256 "7b99d5eb931b348aa4c6fc5b457066ffd19d6979c1a6b9b62e4e5f66479b8615"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a11c8095376a31d10602abeddbceb34ff29661e8bb625c90b63af9b823b68b84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54c767e7422e7b3083f02d491b24af91db959a52c455a8179e2e28979ae71131"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf319b87387dbe54d93e197e4b798c8f46ece88e4d648b2f8bcf6e2488d319a"
    sha256 cellar: :any_skip_relocation, sonoma:        "29bd7db07a503362aec1585b60d42c1de3b64924d6a8bcf4688bef745e54e958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0125a606227dd5d99b955363b8609b1d7c73887b6fd639a56ca58eeb2caed977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9908e76405e17219861c13deb3a868316c20f512d8af4e3e88ff4572e16aaf"
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