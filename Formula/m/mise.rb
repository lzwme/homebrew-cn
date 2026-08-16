class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.6.tar.gz"
  sha256 "52579ef4ce4b9b6b62eee4712a8fc8ba6724e2a5509b660d34d325c514e0d9a4"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "188938ecbeedddb8f30d1acff3741c60ff2b9bc1f9f2cf5b500a36eaddd000b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b203e698bdd7beb759b5fb0a19939aeded36794a7fd8cf94e1b685db7ae3cd87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684f0d6f6743272cf09af6127b0965527c71aa6cc2b28f018b842dd0f5899796"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b674ef798b31516b85eb98ce0b99b0059ebeefb8fb6df4ac1090e101e46eb1e"
    sha256 cellar: :any,                 arm64_linux:   "5a49af9b0a8fe3900d348bceef5297252db07b99e3dc0514ffbd07e8ed329968"
    sha256 cellar: :any,                 x86_64_linux:  "1bf9e8adf844dbfd0ae0e66843cb8cec5c7803567eaa252cf9bb70795b9a3a66"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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