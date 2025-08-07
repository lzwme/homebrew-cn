class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.7.tar.gz"
  sha256 "5c90f647e9060bf23be6d6a2be5cdb5c230ee80b2a6c7730ea2763920b086849"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27088e138f973586c524d514e3ad1779079d10401d510f6456ca09ab8ee42aa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b753a2a5925c03b83fe22935a6cb1d2e36016e1190a94413c16467bb2f67b779"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7388de7f45751b084e80817f5d98dce045a46e111629dd5b008c755064f72a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e5ff8e1217d39e77a6d055ab230ad15dd3950ecc9a1cd98129c5c56cf9fe936"
    sha256 cellar: :any_skip_relocation, ventura:       "c798acee4e21e65bd6fff44bc7972d63471c86a3f706e4dc44d3a03da0ac896c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0edbbfb2270b4a24a9037e902bc338419c2a27792c2d6c71aa7173be86cc51e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0d67d078c7b13137a48b695cb67295e80ac31fbd503c1658a39f4687ffd3ee4"
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