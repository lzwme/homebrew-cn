class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.6.0.tar.gz"
  sha256 "e85144f94a49b9e01af3e90f0f3bec4648531ef501703841fb618fecda8d705c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49dfb912580389d306796c758fbdb5a273d9a5998e3a5d47a7f2219295ab2847"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad3cd4b44b4ddc9247328fc17e0c5f0743767692d7b37f0293d6f09764dfc17d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d57e8b74bfa269c3b2c26a7ef763ab3dbbbbb0116c47196bc1500067e06e618e"
    sha256 cellar: :any_skip_relocation, sonoma:        "567a3b9e67e81c8c3c2fc946af71375bcd77f8b0dde3cc7544946cc43d751607"
    sha256 cellar: :any,                 arm64_linux:   "a666cf0c75fdac66d6caca6531772a7593f1e95bf418bcd2067ccfa81b7c7ed7"
    sha256 cellar: :any,                 x86_64_linux:  "31602a6b06208f97f8c120409dc9f360a3563499701889f60b9d1e7a0a71e495"
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