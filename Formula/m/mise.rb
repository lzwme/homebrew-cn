class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.1.tar.gz"
  sha256 "7365f10ceeb5279de4b1cdec0fc4a02efc653f401c0619fde02f23842b1270cb"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2994edacb758b70ee742be9d05d8f3f1737186e7ee14bde4ed7e952d6ae6157a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80d115cf2c0594a5c189eab087a6f536d179e42d473c8ce4d9c7449ce8fd5379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee8d44be2dbcad3d66ac513a8a4cc08599c39efe4fb5275954ed2c579b5943d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2086457aa8c6b7c10d083ee06df6d6ae98735a6bda90f93f384e985d496cc016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ce0cafd100d2315ef658d61fd62e5b9e857a4a346ccd1b8aae62560805f6fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436630f82caa97a9d48b6c88ace84832a1a1ccabb7e6cfe2c7d36f2cafa2dd6a"
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