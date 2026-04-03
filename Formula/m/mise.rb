class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.1.tar.gz"
  sha256 "13e7242665ba46e54344d8bce518a78bfe334ee7c5124431e08a5c4ebc1ecd03"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e594ea87a72e2026ad02606d738a031968d52f2b940eb7d957146094cd90ebd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb35af1a474e1df7a9a9ea2312f4f3c79066cb727fa46d51ea7787e8b3032279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d4684f5dc6f9edde137a91eeb0dcc3f9470f3156b28e90c1046b378707ce4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5033413d4a4019a02a549efabddaaf43408b5c819e40a71747dec48eef088736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bc0664c0beb7cd5d21fd18c0b41262b192684486041e994d331a7d7801a26cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e226949ef77e224bc56bd0a4e23a3580c049f52f98f8ed140422c4c5869c6dbe"
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