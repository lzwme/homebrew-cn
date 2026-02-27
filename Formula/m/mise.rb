class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.21.tar.gz"
  sha256 "076692d482ab47115f5994b04263a6fbec1e77278bd2da8b1788738f95acfe9e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ad8f3a38b9b39f3e4f66ba4cda905534719e9bd0b77935e1565cf9d4ffdafdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dd9cce8fe8bf0cebd21a3a55e3b8077a6f924978a8dd5cd2eaceabbc05ff6a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b928814812bd5472ca723ecc07a36085684d78ddeafb05a47ba7b34fd4bc88e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8aa057458aad10b62647bc02b4da083514aff942b4f6b447bf9f0c3a4d9c659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b769a2030182c83bdf8e2c64d6cbbb18196a6ac8aaf51907e7a8eb1bd82d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "068e0005e60513544c4f50fff1b22fe4e239dfb923bd628653c73ef80a4dfb68"
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