class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.10.tar.gz"
  sha256 "1c65596cbf9232aa90d7c7d813cd61b3c7982b1f4aad8d95edfb61338aafb7e6"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99b7bfa7a1896ad0017b673944e3480635044619ee4c45453da64b576e82ad35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf611eebd4d1b82b0566681587e94dd26e50e678a2deed36db7a861a9829eb78"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dfd0d09a565626dfe3c376cc13a5ae04d78c439c41dd165423233230d6f0f90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27cc37c0f0ef4dc6716e3195491d472b4604522517435f27f2f76fcac188c1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e9c9d485d816b55b7466a577fbd98598607ff98c220bc9eab422b3f7f3f978"
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