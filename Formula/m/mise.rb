class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.1.11.tar.gz"
  sha256 "1bb83e890256acd32f9c54abdbe39547f5df01f73d94939154479cd469566579"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f118c45964aa7ce76eb61b130b06a75801b548b7701ecec855385e4e8d3fdce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c07ce9e9e8a63447233a79b1ed9d80d026ab9519fabb74ebaf2b9dca781ecd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73b151704fb7620b6bfd775e3075de9ea8a238bad4a31941219c13acccbd9224"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c162d07f784ccd618fbed56f188c8bff8b0b692aeaf844ac5ce77a749778bf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b460e58b93977cfe62eabf33f72206b71713c96b8a344c34bd57f06ffcb8f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3a86f89f56d513f0dd7be6b7d3841f16d1f72772f94029bab3fdaa9baf0fdd8"
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