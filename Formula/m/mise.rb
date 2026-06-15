class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.6.10.tar.gz"
  sha256 "41b6fc602581cee4756b00a509cd69ad12db7293b5fab1e0bc23e28074402a4e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "570e65141c2ef6b683d6813b92f2fb5df1fd2499edfdcc2af0a2274c82c6d775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3f92514c8e2c72c4dd1a72075a8746fc117097615ece04677539a3ea2d663b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57179911cf5baf4184db97d26fce48a1e99f0ff86f3f43e6c170db0a9c18238e"
    sha256 cellar: :any_skip_relocation, sonoma:        "01dc85ada363f8e91ddd8383de45db472923b3ec321583585d13dcf97eedd742"
    sha256 cellar: :any,                 arm64_linux:   "83e19fe8e23782aa9c4fffd1e72077faf203b1ce37d07c3b19afdd457e50955e"
    sha256 cellar: :any,                 x86_64_linux:  "01df0a475268ab9b27a04095993c3e55e641ec3c815632cc3f8602b6bd535ce9"
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