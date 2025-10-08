class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.5.tar.gz"
  sha256 "70b6acfb01a0c4a5294a81b6e7a375adc745085569b353f6fbdcf82495e86826"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7caebdec405e6c2a138c744b31926a1c6d46b82d8291335d3788101f8734ec60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72cfa9c4e55cb403c8adfd14cfa56787d65d9bd66786887cc9b9cfd0a77d6241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41202bb5d18f6fad29f6e6967eda2af22400a09375cfa773bf0477e60f29ba03"
    sha256 cellar: :any_skip_relocation, sonoma:        "7615d408a5a1a6e86c6b4c829c9ce0774f6a46bf2f7b13d9f12f68473bc1ddc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a1a00f5e5c83267ca46722d4ed0d54aa4e55605bd2d3422ed789f1e9a9241f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adcc2c9cd87ab299680d9854ce7ebf18ef0b0099392f4110c1b060b6af4589c9"
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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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