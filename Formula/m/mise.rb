class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.6.2.tar.gz"
  sha256 "02830e5399ec3f2199fb208352bc3ba0e4627578fa274ed3a273bbd3c6ff11e6"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6810b59d0dc9af28ce22cc64e5e7614bea43a1c0a2850b553b94ee92b712389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8bd760eeb5892f90b5ca30ded41a2299dd182ee80b0d96b258039d2bdd794e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b419724540cf48adf23877f5c320ea64677902bf2eaf7b810140cfccebd73fbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c98ca3b98067d9ab7dfafba57a21513bbd1b21401326c0e40d5d4ebb5947f2"
    sha256 cellar: :any,                 arm64_linux:   "e65ecc047842328c11c7b7e41b4f1b357fcb9e8685c4536785f599f66901a45c"
    sha256 cellar: :any,                 x86_64_linux:  "7c5b076af47901a4ec99575dfc8594fd5defc83c24cc638ef0cb7dd782885258"
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