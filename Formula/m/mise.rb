class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.6.11.tar.gz"
  sha256 "b4189990c7cfd2e40ff322e9ad51b972dd8edfeda9bdedd239cf8a16384e0c59"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c87159ff7678a556071965579c0f92904ee0e0502bb5b86d37a5f85f9a0fb29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9801c0978b4432197aef7ea74d10a7bb31b773edae3a75868fa7667c4aad484d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00aeb2fe706bd65866824ce9cbe80227cd2a232e15783ab4af3e05087fd7b330"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b9c9351ef87f15f4f6949e728c0ed848f9207a6a1dc2b07ee5f165a84c36cf"
    sha256 cellar: :any,                 arm64_linux:   "59e526c832105075dc2b431731bd82634f90805405f7e500710abaacbdd1aefd"
    sha256 cellar: :any,                 x86_64_linux:  "bbe5d7ec26caafceb9bc62ca3aec244b71bbb29a0157fa1c764bc37c744bcef2"
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