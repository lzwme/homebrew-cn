class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.7.tar.gz"
  sha256 "82529c8966815078a40ce6a3842461dd0f0f200b4be6829638f8f467f9b023de"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46be728e1405de39d8cdb82909b4c84e76e85fb6abb53901c4ef49dcb3bcec89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697251f701cd21b4cabe6f6bff62c8836a76ffd4557c8db578ae0fae70ee7b64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c153916d0df1924cf8c8c8a7a5f096d179017b14da52011ad0255305eeae0fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "18c415cc8ba648713bb6599600267d558fdbdad950743756ee3dd72f2f9a08cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "613c02b4f18329586a7414b015d9cba85da0e9e85ec95d68dd7ab84b05f49899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f266c0d50c8f4ede40ecfcc1ecdddcc5891a01de96f632af1164f66494704e92"
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