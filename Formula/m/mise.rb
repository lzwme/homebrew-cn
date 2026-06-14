class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.6.6.tar.gz"
  sha256 "4d904b4c321d45d16eb0fc1ac86a113c6efaf122a87a5c89df8521d192564559"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b1378ada6f235e2ab429afda32e74366ea5a5c712478d827ef8b5606fe9fd7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a4e25515e14724cd57312ca6bdb3e39617df9bacccf824199783edfa569e43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "705bf3dc6fd5fed2e1d0e02675ce286976fc19c13ee5fd183eb2906a46240509"
    sha256 cellar: :any_skip_relocation, sonoma:        "931fcaf5c440873afe3fe46449e9eb4db7083659cf5aab9cc1369371e2123d87"
    sha256 cellar: :any,                 arm64_linux:   "06fe6a7245edce41890231d9e75175b38743dce30565e7a187447bd977231b42"
    sha256 cellar: :any,                 x86_64_linux:  "63cebb6958b26af46882f0161b83af7395e9ad3d77e39bd54cc49f46e4412ee3"
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