class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.12.tar.gz"
  sha256 "22731e15e7db76cd514cd02dd9355002f9e42bed46567bcf589562724c362e9a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47d9ed95651bbe6b414ae0ff430acc2edde63b82473ee6e99d80374e773caf64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09751442f9d41f97793e85a3ca543a27e82fb2fd015b2d574faa8111433bbc74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5492a5d75044ecb6ebd03aa7a35961a52c5ec76c22658e8b6b155658e640dbf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b07ec7e3d05bde7a62c7a52f0a0ada1534512f699715b9e44fe7554ebf68b86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee27a3e30de664f84b9cf8f1457fa20c781bd825e4a42f5c1d9b7afff55882b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90af63db0681fc2e1f82e3c8c3046b453cf131118456d1333d2a69795d9843de"
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