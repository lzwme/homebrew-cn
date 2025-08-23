class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.20.tar.gz"
  sha256 "f92d22face0128612fe27039f80beae0cd30335240cb7be1aff22b429048f485"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f99459f3d7e8e8d64825c68980c00ae6d4a9e2b6aaf146c0928db15cde0ce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c86ff566010a7f2c61ad4e02dd33411468b4e1f7c0b5f5d2ad4d486e248ea57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b09fde792924f75be95f645dfb44f2eb01c5aaa5df3dbd20e71734396b6417b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b77ecf75cea7accf06abb409cc578f9d1ef8a9c20f6e1d1a73d9cfb338b12bc"
    sha256 cellar: :any_skip_relocation, ventura:       "f3b163ee9912883534ab9b8e7ec93ddd4edcc7d7a1f4604f605e77b5ac41943b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "178b9b77231d551727bc9417d22f5960c0e71a4c86d4262e812df6b94717790d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14bb30cf60fbc93a10a36f92ba74608daec1fb90cd55d659c84e4f1faef03651"
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