class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.12.tar.gz"
  sha256 "f3465ad6dd38be573c18389d9b8b1f7e6eb45c7f9eb1e4abc669fdfce760b96c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d1635cf142f1744034b13d2b129f317db0c75f286d939e53ac90034326c36bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89efe88f51293c3f6fc18ae491b1e13d4f284829e2899de67a62ac4c9ed3b79a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab7c40eccf2f15c1026091bf4f3994ea8067dd0079fcc28af0daa68c6433f196"
    sha256 cellar: :any_skip_relocation, sonoma:        "6176dc647de644b91d0379bdaa8c1490b719b42236a2e6db7aed5143ebd8f8af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bec9d3aa62643dd0f5249a2fac3cc50dd6c091e033958a360c5ca7b50bd0e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "060dc90af50479c610bedf48913de97ad64112dfcbba427b8e12bb9f99ab0f7d"
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