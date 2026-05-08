class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.2.tar.gz"
  sha256 "6a43c8b4688656fddb0024f6850b7eda419a61468a473b5b2c8eb3b5867ef9f3"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73e84e2569653ad81c6664548dd04d148c98ee124d19152f28963f50a357d597"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d7869e725a0037e2eb37ffcf4a069bb693025d3f93057bb751a107363e6c084"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8d6769020c193d0668259c49df7131f7b5f7417d7b2369d10519efdabb9b859"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ceee16cb7bff22e4af980293d51ecc7e45b3cafd82b6a2b17eb6e456e53a097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4074db11c9a8278ee9d699d41a84ba57ef3bdd817117193949333501d816197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83b772415b47a4e60cf3a2f7db37c3382db93b0389f83d701faf9fb3db577415"
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