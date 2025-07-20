class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.17.tar.gz"
  sha256 "a9280eb979701be5f6e14a2b60db273d089a6c6d7e9cfc22040e3694dd226378"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "476821f830f698f584dc875cdc335ab4dd3167e54b162ac65eef25b2194de0af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78cc58eac1da5154c6f4d61a65a2a55d7052e0b12a3a52dd51ece88c9d0e86a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ad178fcce702b329519d0138cba14cd6fa2af9cf489853106ccf598a9fd234f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fc3642ecf35d44d8dd5f7e6a0cddc936e1a5105cf827c62c5bdbf8742843391"
    sha256 cellar: :any_skip_relocation, ventura:       "d250d0357ef703d0faef5100d15c56a45a905ed7942dff97351ad7f113f503b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f676ac92f605ebdbcf9a13f24140869a66199cadb36219f594cbffd4a7449a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "357a55001f28b822b6709fd0cacac99dbbd9ad7a65c053209e7ba87cb84af952"
  end

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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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