class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.11.4.tar.gz"
  sha256 "ebb24d06c76339b9dd09320c4af608289a126d05e8fce2346191aca8d2db1c9f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "404f7c01b9b6c5f0f2b3b74ce1de91c7e400f95e650dd211a61b8eb9aa172583"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed4b61de95ae100895e104856ceeb4701934e75ce075156f4591b864c1be5b91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82a5c77e2db036a64b8a8e35fbccc8c0d266378eb14d0309d7b49acd3edbd7ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b132dba9232f83c35ad87a75cfe474d9b11ced27d0170a492264fff82a6a8a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb9563902c29222f224f965abb3c2747c8e66ccf773535a93294d8772d4452c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4901df92fb26b38b69f00542ad5c4791b3d0a16b30bd69f32ce0370e1feee87"
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