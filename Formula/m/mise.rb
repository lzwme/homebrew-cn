class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.13.tar.gz"
  sha256 "e2358c8dac14c6c7db98cb9139fe9cae55bd062fdb9b0197cc6b03e088bb7c3f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9684ab1dd21608c9c6d9a939916a6e91f9f161dfbc11e80faefa2db37320951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdae79946e6bca7ab4a1f3910fe25549dfc6863b54a91f31c614e6c45ad0a90e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4209bd9d68355e43ac35393931cd12dfd65b1d44d1ac50854c758584e6996b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3187d98d37e099d5760cd1b89c3a25f3fb969c2f08c61c3989857d6af417e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e83c3ca967bdf309458a171beeb981956567cf4cbde4270e6afa0cf3e809e912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9e852d9fab53c5e88bbc3a52ebf9b79799e24a9c2832413ec2fd55e704d026"
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