class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.11.8.tar.gz"
  sha256 "72c90f9618b24017184edc8bf15bb0e3ce47809b27eec0e8739a6b02c7c5d43c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8da596098e712b430c3d860005ddc65b1d67aa8bf1c18d7d4114993a9e964df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c3ec216c040c17ac241ebb76e891863d00a3d47f07dd0e265c8e00ea0bee55f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eb890684c4638cbbe3db16cd6b9579cae63ac3db7e473258dd6cf3c08268636"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad85473c4221f48c554005c38dd8aa8d32e4e25b3c2be76c9da836eb2b0bbf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2fb275ae0f6c8a16844c083c2f75864631330b410acb61bf32635f07da2361d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92aac75256f0211de07f09dc68be78224b2087bd599dccd7084e1f66a8be5eca"
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