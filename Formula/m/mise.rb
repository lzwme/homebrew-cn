class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.14.tar.gz"
  sha256 "e7ffe04e2253f02f1adfed28ffef1cfa41321efd248fda59b5500e09ce470c1e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65708649862d16734e4df5bafc83421cb6c092c4e1a55a41f69cd16046b7385f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d10cb2545e05182e15c3bd40805d203871fc1d8000cf5cc5b38fc6155bf0cf51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b697912963c6703e8f151e661767e45153db0f5cdf3d7355643f022773c8b166"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa576b2adf8bc7093b983aca7eb69a61e2c643ff8171dc6e60e2125d5a7cdbbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c640a63954d38550a84bbcf5b8faf986f42a07fc5c5a834285903d8d08be1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8610d4f23260907d2980ad95e2903f1e3d29b644179fb99262815c6832efbe82"
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