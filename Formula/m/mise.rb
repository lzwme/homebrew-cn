class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.6.tar.gz"
  sha256 "6b67794eea7dc6c9d59da4fe8aff65159de58548c1f7f97c99969cba1a18e4fe"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a66cb5e4dcbe1369fc47d9e36a658a1c6d186b200304e3920777ba290b8a636c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b555f0324377a185b9a3dc3dc7906f882ca79fac4b9f8dda7157c62336edd73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59d67668fa6e9402b21904f923128b4511315cbbac613391d2c37b949c1db529"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dd0048ea98a0d90631957cae7ee2eca6938450278b64e61f25947a46230a17e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5f727961dfd4e5c5638951aa027891d6ea13037a0652e1c7c6c66c14108ca00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417e55367bd827ef4ac0b4ca173270c1664d029275a9eb0f524a95429c011de1"
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