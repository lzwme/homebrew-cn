class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.22.tar.gz"
  sha256 "0b33f03c33316aae9761196c08fa33ac1c38b62102035b10bcc9e181e838168d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afacf7b34a6418969ed267401190f3ea8b38948870fcc96aa9d3661c7954865e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b6be65638d69dd3d2c929ae17b7849228ed67089ec48d4647f48ed9a39b542a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1f704ba4e5031afcda5351614529f0c8fb460d739ce525e3107ed69cf97f454"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa7e2eb312cdd38c166e6d7e2e499eb3a1236ab1e7813c3eaefc8b298c97f26e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "793d2ab060e3d8524abc625c158bfc7524abb55a18089938c8f3a82aa874cc95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "970d576bf31f716ea9fdb7358b75bae8674ce1e7ee783e4ce3a7c730ce9c11c0"
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