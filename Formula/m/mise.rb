class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.20.tar.gz"
  sha256 "97774a856c81f061604b05786e27f050cf9fda1bf29e4ff937a5eb3964eed16d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4fde9f58b2306ab1fc6059fbc12432d4e9924720aa4ee9e906e45176dc31247"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cf987da8c789c6ce9f6df11c2eee960ebd3311061d4f40dc94444793251a587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec80b8494c653860d6b9b69dbd1c9ea4f8d819607f80746f18585b041216514"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec3a6491b21c8fc2d3b1111ddf50078535333b83d0e4f2bf93603afa71ffadde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83817457fcce1642ac82d098a521da424220b89fc7d580e36a34343323b59c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc262862f7ad30990e95d5c23bf70e6fa715a6b95585852897266fc791838256"
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