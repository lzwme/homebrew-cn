class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.28.tar.gz"
  sha256 "cba28ea77ca313754ce9b5bb2d906948df8e3880ebf06189d548fa95646ad45f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4a1df3e64c2b50eb222e54f709a2a531e7f66e3661ad8208587e03e8599b754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbc265f896bbc918d765fde11b686ea996be4d3eb5df465dda3850f6849c8529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f057f489562ce701f0d985231b0bbdd8b97e1f80d908d030fb355fb4f5dccebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "d340e056ee58a0feda0429d98e1668dd4e2c8e7547d3fa13e881a2e2813c80c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb170bf212e3c62750b31cddf6dee9e7193397b0e156871b9f1593550bdd560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a277eb6a50dcf714c43ec604908b83c568923bc99e57b1e64037e8a470957ea"
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