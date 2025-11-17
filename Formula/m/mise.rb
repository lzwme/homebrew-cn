class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.11.5.tar.gz"
  sha256 "3afc9f12571a60d66423e7e58549d226f9fd3b8dbcee1b90b416645808c2a23d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af641bd2f08a609e952514bdf183722674fa1a39b88e244b46e76f4ede9384ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "724e28197b0828ada993fd0aab90d414bfd2dbef7de9aae7bb871c3502c2ddff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d365add0097b0b95fe1fa9fbcde101ed948270b47dc8164ed5d8a3767510702"
    sha256 cellar: :any_skip_relocation, sonoma:        "33e444efddcb0bf1206613548f7ff44f188bb8ada8bd12e5552cf4ebea880120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76ce26acd73133ada9ea2001a7679a7a18908b087c15f9915f555ee076570a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e1182ac75728fc8c997a828f1b041cdfe321612b773825258ea2645b1335e1"
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