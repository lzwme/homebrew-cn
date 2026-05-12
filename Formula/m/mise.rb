class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.6.tar.gz"
  sha256 "9d1fefeaf5c40c41ed2930ce22600dc8aa4a6b1472edb0c57086453081995a17"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63261f99ae0fb273f107a6f8e2eab0b3f52056724b9a502ba1b84c304c552669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c1f76196020a03befab10c02beeedf4eb0639a4c35cca3209ca2600fddfad1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef49c123bb73b7582c91c7253078ea38ccaaffbdd8c141c457ed2745ad319dc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bff89b094eedbc8423f80a4baeb996dafafa8ebb28f669878993aa6818711bed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877546f5864d2733febff21c36dfc1dd4ab4800119dd59ecb3ba36fe2f3b110d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "320ebe7d67c4386a104b0f536c86c555434a70417478372b064be35de15d4ec9"
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