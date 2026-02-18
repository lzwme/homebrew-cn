class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.15.tar.gz"
  sha256 "674e7cff7585fefab6ccd45e3030440b4cc5abcdf38a4147503d520ad3dc21a0"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3761d2f84f0120e410415a6c128da13a648f0d52ef130de2d148043d33f74f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be1d1ba76b2807fbe59ba22459aad1236f5edebca5d4b1e923704c8c201d6f3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f934db29936c25898d1dd31320d98c0f3baa632abc41ffe88f9e5b9c89df5695"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9c1ebc93143643a1e528c45fa303f60e06cbca9b1eab7e660174019ce9d7242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffdc3da65e608e59a465dbd68bdc0ddc0a0ac7f796a0e2ba45f7d2274136fbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b91b430926dd1fe8ddb8d57cc29d2840b0870856fdd31bb63736074bcd22a24a"
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