class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.27.tar.gz"
  sha256 "c499a7ce733b983a364c6dd03d6083e18558625082c0651368e7d0f0a7bb340f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8ebcea489e09d50ee497d6de9109884299650cd92fb7955b33236064f02d8e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9627b68cbc666be4658e3c9f20f8dce666c0be094ff845e60e989fd6f0f14b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0e70a6ab7059a321f2cd549f72fe2cae4255bb810196f9996203c031009d563"
    sha256 cellar: :any_skip_relocation, sonoma:        "9da571b7f73d41c57e1e5b6fa0b9c9a53c20dad0a9ae41fe24f01808124f431d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f6caedd77e4bd756ee79d659b5d68407c676a88dcc235387feb0e285dc385fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3badb0fc20eeb2d57735272bb3223931513380a4eee1ba44d5dee8512e1999a"
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