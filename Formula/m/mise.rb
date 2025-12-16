class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.12.8.tar.gz"
  sha256 "7bfaf2a4c48af5b4e9437f92f77ae8161e8a151e860106280cc2eb1f6a57ba29"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e40f748c7be8f6cdb4ef143ebecac772302f5e6ffc4699f6051990f1d610aef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6adaf188d3ff27b74d5c26ce56565a1cc83a42f6c5b78b77e1466f214f795ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ca22d13b820991873517a5f35e19e17e7a00fe248030eb1e6f2d4791d7d3fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e77f94e120e83889c7d1f9a1396fb3e5fbafc5f42e538726b10bc2f292cf455"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ceb4cc8a0693502b509544825399461de1e18abe97e186c60b05c28dd181aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eadfeffe72008d9bc5012f7de8eff5ea42f87aa54a368c3279aa63edf3079d9"
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