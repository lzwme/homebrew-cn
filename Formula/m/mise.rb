class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.7.tar.gz"
  sha256 "6549035194f6086cf982bc17f303aba44793c43d3e2431885fed619236c1801d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e37f460b204223ea2cdc6bc71bfd9a14c42d3ce4af047eb299d5d631a91051d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1f1b714dc708990f64f425ea7d3d56e2c1b7f2070fe38a8306feebcf7dbe55c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9b2ef001e4a218c23ce3791d7e334952d13f4310e13f0943cd297c77caf43bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9dd4f0dcd0229b7c46811eb89ed0298d8953c501f33d0db53bf5c382a79e644"
    sha256 cellar: :any_skip_relocation, ventura:       "c76b18b81dc77a2e85dde480c26e97b0a757c88eff52a5892df13494a5e605ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc1593077a25db1100dc69cca8c762a987a14e8048c04681763ff4ec62506bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95d729307358a996725b2d125d59325b9298c44e945648985ba10586575c3f91"
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