class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.9.tar.gz"
  sha256 "f3b35d8aadc8db66d77f406641e61858dc4553778e520004220d42085058716f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f36752d54e68b7762c22a47bf516c55a91b673f6f616e01add7e4b1910bc273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6173759c7396ac3e6e8ec8f2bcf937a0803e95544f9ed0526832f67c006c94f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "727bc7e90a0f9ba47b0e9554e9a38b60c41ad0370e6652983c959d4187b09781"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c0264be07f173d04c92d4588cb86a81b4b42d9a9fce8e2e8a8fd505c920ce7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "567ee1f041b67a80ca62925a33cc62279a22d1ccee921f9b698eb68d9cecb214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c8bbd2916f283298c1e1e59e08375ee2368bb8f55f3bc19bf2982797e7f0f39"
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