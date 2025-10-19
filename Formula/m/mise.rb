class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.11.tar.gz"
  sha256 "1c84ef83a584ddfaf28d6d3489815641916253925cac0acc8b5c6ebe4764cbf2"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52d17d588e8a11e6556da46855dd28c0bf2d5d4c3697fb8b8c93050cb87f204f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd423f1770e4359cb515ee95d7f77fb4eee997f8e3621722f5a614b2b6cc81e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a93558643b88dbb7c7f2f320724343444bbc4f1c9307800c9b9a56bd3acfac"
    sha256 cellar: :any_skip_relocation, sonoma:        "62dfcced8ce41a10c0066e0d89ed8f8d901b787d45064e7bce2af115ba6a5568"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "473b20438fc7b75be82a5dad0e26b1f310c34f9be983e354a33b4b02a8a99c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "320736a19a310b39b8098d999cc76b61a9af44dfa3b75bf89a956de14138c674"
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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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