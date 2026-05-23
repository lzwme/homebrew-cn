class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.14.tar.gz"
  sha256 "1ca9af81641360fcf387efba2a5cafe5085a3461d8df81beb7c059bf6b70a925"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f5ba9b7688a7b7779fb038171a80bf565883e33b2465a6f53fcb4599fa4cf3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beca2cf828442a3b96502758705ebaec076644bd869e174961033da72b4e5f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bcf73c3b18d91ccb874976c4d0946cbe33fcd35f90ad4cd2e3402f36b429fc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9555f4ef0baf40096103807d1e7767d59e25a9c8a7207003600761889f65e6d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "833ea8bde1c0bb2bb255462b8c387bb54b90d98cb8d48e1e5880d39549b8b96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d18e74d588af9667e6e4cd7ef82638750e4ac06037f9c45f87036e4b742ad77"
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