class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.15.tar.gz"
  sha256 "b955c45638a32f1bba263854e4b2e8babd65fcd66cfbcc997b02b74e609a738f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4f8391c2520afd0bca8f85ca1bdfc741bb1198892ea1cad8add61701877e7ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb900da695b4ae1a045b779049ca28d5fdec9fc9c581cca3123b7abcc10c6c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775d73d3f85e377871516ed861bc5fdf7f71572cb28b57bc506d345ba3abb3a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "48faf63817a3008ac8679c08333179c2a91440f0ac58f7aec80a7c9ffe8ae289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fee7bae8301af04b1a17e4a9ca62638ba6485b3984213621de31a6d414869c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c79fde0c47754d28d9e2c28d0f356424a431cfd2d8da6a7df4de3467963ebd"
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