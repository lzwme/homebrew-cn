class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.7.tar.gz"
  sha256 "3b5fbbec0cc2eaefcacb2410e3ef8dbf51738a055e85cc28e4a8b24843653685"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d7b74f187783857be8bcb1d86366c74aa8b51e797dce8b93e1625d256e6396c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d4db554b017faf5892f7c73340b992ddb982daec6d3cd0d29de42782c4d1e4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405923fee1eaf433eb819a9079439730cf16f815df9a69e6a4229d52b9fb082e"
    sha256 cellar: :any_skip_relocation, sonoma:        "963a43fbb28a39299424ebada8fcb2364075a59a09b3eec4ddd988152e4eaa5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4b2a73e006fb07c0eceb57b1b4f977e0d3a7442b28908165ae941749aa5ed82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d4a4c7d0ccb15618f93936f0a98a062cb45893ff48c1594eea0ba7d4ba30db8"
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