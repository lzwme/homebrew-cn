class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.19.tar.gz"
  sha256 "cfc0c92938c39336507b026050961ab5703421955f7a8fdfa70c473884204972"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef3dcc7188464ca3add195aebe6f807f77a189bf96e5cce71ddc04f4a892c622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afa6245777b5a120d122b0c74e4f1af6e54ce46a164fbe942e4596cca86122d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "260b0eb1faee467b625e369a39c4df3be5e801ba40460ea772ed33b1b361e21b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e50f3cede1d2c78bba52ac05b95082b1296a9a549ada62867fe7ecb803cdfe36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6549d654a6a92a180b7d6b7e6fe1688c9c45c2becc79bbe70e1508fb74cbd43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b90a1723558b5ab70e8cf5a5fcbfb52445a7a023e94eb9b692f41c1dc40e9ef5"
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