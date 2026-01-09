class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.1.1.tar.gz"
  sha256 "0677c3de46b27dee4e3123e5d37a893924662531cd2a829984e4d88e5d0060a9"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b931648669005893350310ce088b0e178a996403a5b0cbf8ce157aebb07eeabe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9ada8f7a40ac51f915127a005c11085c1ef4ec3bedd668b735467eceeb6dbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64ea050143ebcc5cbd622a1f22c1b6e0a6f6966bae369a667f99f6c37c165372"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c1611c97cc04a28882de3be588dfde96a5c8dae2f4aea4d2dde2a4ab7299d52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b75bac1e62d6d3355c3464aac74464393539890b5b26efc0f06db365c70dc54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e034c21d9b326518b7386167df1b5ca99ea21cc62f29522993dc8186650e411"
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