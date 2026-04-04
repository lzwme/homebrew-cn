class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.3.tar.gz"
  sha256 "8afc088e854702de4c0dd79b58d1ae827b8d2ed4e9d4d07cefdd29afc2ef5939"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4088e794639217228d9b795a04265def44720408ec8b29705b137fc56c54430"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4218c493f80c61e08c4b4929f3a6fbfeda6eb00d3c258e66278fbcd1b95312a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec0b4a66425c1a11d63135d87f719dfec9210b0351600724b09c5f7d609855cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b49199b3d3570fb823c25d1132f500c1cac8ef9bebc405db51ee86842c1129e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39d23c7ed70f28384da55fe4a60b67bda4cb74318fbfd9ff0c80953cfdae87b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2e3be5cd8c58545b76227cf8cfe4460e60521e8af8d2b812f2a62e6ca36806f"
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