class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.1.0.tar.gz"
  sha256 "81fe1d298a834bdfc01d885ea2feafa3d9a8a654b0bda5cde537cbfcaea355ad"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3f4398da35199ec5fc24f178f1a4cf2c76dc00801b00fe482b7f0d5396d4ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1886c7e6ef5f7d27c8c21f55101a3617e3c2d6712592acde44efa9501ce72fc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6f9f19f7a99c6a33c776034d37074592646c7c3a38917499044f5c3993d5d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1febb046fca9087c24e07d82a6c1c273fae7541d437bf506dbae983031b4df90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ed3df697536d3b0a009a39d893ac50bc6ae4c4d81fd35f8fc619d922313687f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee86405656ff1f0a59b14995324de4e1d25443a050c2197509b119ebb4d445b"
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