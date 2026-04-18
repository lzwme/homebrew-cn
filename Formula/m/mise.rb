class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.16.tar.gz"
  sha256 "2337fd999874a2fa5cfa1c51eb54966d2a5cfa550824026089cff6b6987395be"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f523c87bf982104bd75191de3390cdfe13812c162ff7fcb47eb6ea5cb2fd193b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9db7ed62cf365b70c29aca557fbb43e4a45292313c774f702d2d300d4fbaf732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1385e94c3342cd572a22edd308a17e7566ec8be51587e2336d15559e1180e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa2d8abe7b061ac2bf9b457d833bff2c9ae196d512c2d0b373b0cc93adb3b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6a1d7d5f6bedb7718fe34f23420cc859ad2929a94c60cec7caf8b43fe0102d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6c43feb8cc312b4fca45b9cf3b1df3f12f17d28078183d9ee797853750a1ead"
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