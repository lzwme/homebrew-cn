class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.8.tar.gz"
  sha256 "3e8243a62045dc7825e39cee578050bdd5ea3e86f29a57da50d4d49510cd863b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a80a4f1d6592c8aef6f592cfd2fef362c9e41444c181056af8533cdbe115769b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d2c1b1fa4db98f4fab373e0bbabd36a82bd4d2b498841137b17f611d5506cb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f91d3ae7e87abb189093ba9a91ec95d819bc73e390f8a754e1f317ea4f47c370"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0f7f845150833f6247edfa5fb24b321622567baaee3d5ccb52da75f737eca9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3df4e5f9881d1fb4f4346f1285b4548d64aafe9ec58e41ad81102c209737f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f45d5ec8a66ae5f1c15be2eebd313244616ea19aecccf9f11d800e9368afdda9"
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