class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.12.5.tar.gz"
  sha256 "4846510eafb7936410ff1317e6999686f9dda6ddb4a27b5a8d7dd62dfadc9555"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba237a29a0ba495f577071bd944595f914d576879532b092d3f5ce4742b9f34d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5777372ce22350991136252f8a0b6a248a8c08c0aacb00b018bc60fbe5cadfd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43982862212c51830949a6c254e8a0d6399d9a7610f38b0852f584a221ee14dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbda848eb372de0ddd961722c1a2e40eef0af5d83df3a961dedc1a4ca7ed0590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a92becc89f3c69ac833fb870e71224d5f7e2a160e460136276094f0d56be726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab76c220a33e51bea8259e577ae68de4baf230a72ab57065126d8c0d7a57e352"
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