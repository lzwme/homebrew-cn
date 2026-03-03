class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.0.tar.gz"
  sha256 "d05355b1970a3db94be77d32e9ed1f106432417ac58eb851648a91044d1b5c2b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bb4f315f940aaf1c8ef979372169db9d8dd66c247efb64d104af447e3fcaea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fe5e28f02a87ee1042ab3050e04f6e85f9f12d4ed94353f001dcc2e61dfa29b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766e8bbbae6c4a064b28c4b5e6baad94ce5382e35af25608042e91346a36d2da"
    sha256 cellar: :any_skip_relocation, sonoma:        "108e810dbbd6adb35e2bfd15b9f59842e690c4062e98e8b232a8e21686a20a84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "577a3faac9acd42003af2a4deadd0545c8546aaad415adce95507485026bc9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bce2f1318b372c1bc4bedf5ab7e7e4d2475fafff1f5ad7fc7c99efc6dc7adb06"
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