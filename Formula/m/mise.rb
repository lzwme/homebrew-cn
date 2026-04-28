class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.24.tar.gz"
  sha256 "51f6850cffb513b049aee524fdba60cf41cce9ecaf30c7814b158c42d9bdad49"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e8c938d20f2587d418bf4f00702931e4d2d1d4359878bd6c1e508d70f35e962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "975faffc6a2c966825fb333fa177a5b2baca0e717959b6a76b7dc2064f417984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa9e535371ad3e7de0aa169b88e0d3c392cde2baaa23aa5ff2d3c03dbbb7e2ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "59df07f271000c526317373b4b7a107637c1ffd150f12eee915574a72a967ded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb53fe9a9ff4c5a4b22268842117af3be97bcd8e034580b25b2d0db34170bdd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb0013cd4494ab19cae0851eb33976a0619efa6e2aeb45e8eabf20a5b3b58be"
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