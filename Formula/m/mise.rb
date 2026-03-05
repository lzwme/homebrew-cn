class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.3.tar.gz"
  sha256 "72b6057a34037919014a6b822cd3a226a8023c6546780acbf9b56a1403c55b2d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c03fef053eb3f29752c2933213882ccdac6c5512e6256b6af03a54d0749b7186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b56f20c6af7250637105b91b81a366e138cc972a0fabf7220d04677fa0d16f55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ff8a673de7d216e52ef754c1125cc93fb58d389cd8c9781c20f3ef16e8bd0a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba43201aafd8f1a949a9587fe57928845dd0481bfd62ff531bc7ce80b6f57a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9b1699702d2a706cdbc4cd59d2443a968b0f0284e8fe2c81f50e182b2f38002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fff3abbe7b54807685e0aa3737a56a519fafe13ef7da58c7ee5b1154ec27070"
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