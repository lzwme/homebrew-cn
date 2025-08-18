class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.11.tar.gz"
  sha256 "ef4efc24abfb4f2dd71d5a28fca115dd27dbb1eafd38e2b491d7e9b61c108952"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9298371f498732529d33dd2c8554959a776f0e974f3dbf88968514fd960f9d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53f83b1bd902be0915a6bd059489ba461f2efc6e5db32872cd381ec8aef55843"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b731e1644932dea227e1a0cedfe45051e6f71855d581d4bf8e7305b026798c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "485503d78dc166a182e9a05cdb7f78e7256a989780aa9ca9a8ce0ef4ff0f65bb"
    sha256 cellar: :any_skip_relocation, ventura:       "3b172ead72cd52276ef088476757abe317b119ecc02f7ccf133d07ed1d1abc82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed03bce223255744a33af4f2c49405a4eaaabce22bc637d5435e950bc9f9f818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0306d31f246cee178b2cf1d71d7b03e0460801a6a55208eee957d5bbcdd0295b"
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