class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.6.7.tar.gz"
  sha256 "5b1ee17466b158ef1ba1059531c9863fa2122b72bba530b78d0f7bd3c08811c1"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "496a8f249be90437e827679110ef9f4edd3a64dbb50c340957a89ef1f8bd554e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33c925c6aa4268b2aabfbcd026804e6d16a5e1dba619a56be0a46747edce32d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32056673dd04edcb571bdfeb3caad165752a79b1e0117f5e9f2a40db6721c84c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3780eb2c931d2c88d8adb4a820aa4ff84f6c204aa48cfefbbe5d74da388b72da"
    sha256 cellar: :any_skip_relocation, ventura:       "c74c78259650421386a1e29e76f4f3fb76e54fd0cbb88b58254f155498c05c78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e927d285d6f66135a2293b9d11aaacc4e768fcf177ef6a4128c222e1a822dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2e773f9c660a07165572e33399c24009ab7083456b0c40579f3bc2c66054736"
  end

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
    man1.install "manman1mise.1"
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completionsmise.bash" => "mise"
    fish_completion.install "completionsmise.fish"
    zsh_completion.install "completions_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")
  end
end