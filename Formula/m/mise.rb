class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.11.tar.gz"
  sha256 "251dd38e9717f793786c5694d95f5a4fa8a121ec13482679f790ca3918216a93"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cd56e4bbe404564ca3815b44b53fb0a0ce7710853a6cfc0e7309f70d453846e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba8d0acfe757f9b5b45be8157facfdec0fdad0d60cf0c1b6b1bd437c7c1136b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f337b5b753220b97d9475acace21e2ae0686e457d671c28779ad843da653b069"
    sha256 cellar: :any_skip_relocation, sonoma:        "d734d94e13c183b0294548b8ba38d9449f9be069a63e9d6f5b7e968f9bc4bdb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9824515f075ac05a43ec1ca3a29e1d5e5bc60419b222cf3b69f64dbbf5a4b201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28850c7be19fca1fb444de0dceb7e295288621c62dc502681bace162604a7414"
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