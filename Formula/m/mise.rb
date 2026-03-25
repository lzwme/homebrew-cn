class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.14.tar.gz"
  sha256 "7651a620b12182511b0972dbbd81a6d6fc0a4ead402ec28f8f6b0fca65ff4696"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cdc9fe0edf87154d6d0c6b8ccd425abf264725c4c56f7f83bbe583456ca4483"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0befaa0054d506e0ffff44bfa8efc710f089528e93da20475ce59a552b847b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8706e2632443a8b3d339a33733a5985c046be641e085017c037f0e712459c967"
    sha256 cellar: :any_skip_relocation, sonoma:        "a327191cd0924f22dec021756ddee7a0f9eea5b0b4884a37ee82e8a92448e761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934f4de5e242558601662282548895930a1da9ae83dfce4ba3b454cd19231ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c1d04dbe5cdb824ceb3de526acfc4ffb1aa2c5837c7deca025d6d702e99e48f"
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