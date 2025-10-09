class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.6.tar.gz"
  sha256 "634fa83c83709cf38d03da31d5041121963d1860f4fda9cb1c97a438c3a645b3"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2f6ef344b7b03c0a7c831989e98155766ea1fdb4cf91f6c85a8f16ccc9054c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e73c877f524f83ea9d62e10179d063855a4ef7f46c365b6cccd5e44ca6501e60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "777a7156dc6525703ca2c5067bcec2fecdc303222e8592304ba7a4dbdd5baebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a3d0490362460c4f6996c024cb417f432c6d38dea35ef6fd5e903f32f021862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b3ee483c855e130ae1376bb7db5ad0ddcfcf7a050964545c2e88f041abb621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b22b5e028ef0a6a2e35d59fc405680e1f92d95353b38a6ca7850d200185e2db8"
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