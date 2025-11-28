class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.11.10.tar.gz"
  sha256 "a95b43512d96b6f95df5c8dd48c228d746c8ed335e4aa6054f82849493dfc083"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0ccf42767e106a9eaca4a169f790dea6dd7afa08673d185186de0dadac6e704"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0226c2998635f9bd81030bfb6ee6f433e3a6d4ceeb24e41f15ae3b347f839901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9098454ff14cd0b1a71aee2e12ed8d6ff4cde16015bdbf33032624d916b172f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e6f2dcd62a19c14dfbf417dc6253575bed9076126c53f91c98dd76dca7f135a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b5fae58ebd46da35640f3c59b327adb169aa123afa032bcd6c7910efab86252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c912307abe92c4c38b8e7c0a36b92ef8b55961e1326e13ab83ae433f828bb1"
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