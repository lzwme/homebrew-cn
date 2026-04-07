class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.5.tar.gz"
  sha256 "eeebb7f7615081a6eda1e37acae17ffc67436d6661730e1d2e948301e91498d3"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14be55c5d17a05ffe623b87e61a7262603df50c5e2d1fdbc9d6e544966e1bcc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48edb9e0578e08c6e8f72bbb05efea06ef62ce7e1bb109fc42c0d9a9614b281d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8daa8ea0c530422bd6849f3176c8307a6699bd09f71ceef8ab37c927777d3adb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a8df9d03e6da5e24d7c55ee65d5cc0a9de41e0edb738f6f9859b354f17d174e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c5acb314033c093199143f43d43ccaffea45c0f0718848b5c81d2bc838dee4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4aee578a25792318623873a405117f1cf3772e1d6c11304d7a793b93b7f74b3"
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