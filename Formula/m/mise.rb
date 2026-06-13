class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.6.5.tar.gz"
  sha256 "81d9b27a067cf6f91d071b9520a78598524747df1e894f9fcd4d03ae339d7748"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b1ab3d6024705be33a0fdedb5cafc862752ee23a925bb96e0926eabd0699a21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9dc15bf55dffef281ac375da18bd248fbf63814a152c49912f20c8a4cccd257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2057bb53e53db372a27f36b1b0e434435a89506ff828dc19cec9b5e5ceb7527c"
    sha256 cellar: :any_skip_relocation, sonoma:        "98f509efb27c46718e3b3cb02f1c1719511401ac2c85a49cf4ddfd32300c5999"
    sha256 cellar: :any,                 arm64_linux:   "c35e5872c229eb65d970a999ffbdb6cbc55384b267eba5295b9a66f30bc12800"
    sha256 cellar: :any,                 x86_64_linux:  "470f3700aff87833cc61829a1c43aad2f7d83968e5578dba1d8b6e9771e61f26"
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