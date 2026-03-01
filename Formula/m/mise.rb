class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.23.tar.gz"
  sha256 "f9b455e9fb08746070c195a35e1e156de93671c4058eb5b73240ae687d545aee"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14ddd9e94e261ff1a108fb66e42fd1d250bd2a4574fdf31d4247ee806a235234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2df394a3edf2aa0800b00a69fbfda2bf37c8da2418dc853acb3c2c1755b261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3862d6ee07085d500fb814e7026542fd4095c1e4fee3560f5276eb19eaf6b19b"
    sha256 cellar: :any_skip_relocation, sonoma:        "08e6b760af435b222160647eb0de37e63a0a9bfac0af3cc96020a8f5ab058085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "054e8ccfd413ae2786305c226e2895b1ccd0a61db998f05f5049f4ee0b24f16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7729d9d647de04573c14724fd759723b068e4a8fe501b034820b9110ada0fc27"
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