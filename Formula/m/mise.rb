class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.8.tar.gz"
  sha256 "eb8ee4e593bfe89a3b259a321b7899d4688084edc14822cba61833ea144acd3c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10e68f5e45351be8131bfc9f519a6d09b636d92a378ca90298f7772993f8cb98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47a2a67a6856f0c42c49742d607a2203626b7fd42163100e207b0fc26490fdc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45ed6abf396f28650e5b5cc5e5a1c4a35b1b102a67442b4fd67a3adc579448ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4120efebb991e4f202deaf922c04623b69a2a825710439a92b7f361b9d7d609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f7f65f576a6edf505485a262f5d1b24e33215002ea9c24f0fb83124acb77be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531320c66f472b2fad2cbc61adef3f588a5ebec66026bb3d4a9dfc8db237c280"
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