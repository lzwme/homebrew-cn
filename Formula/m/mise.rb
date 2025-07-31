class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.31.tar.gz"
  sha256 "bbf0dd54962a8f8082fc287899f42f1f7e47b61082a1a43148620be019991673"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc7012723b6266fff1587b6cc88a26553077f61885230afb8c0566482e7df5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1ba44ae50a8ef56bb4e703c381a9255adfb414b2bde4d9473b6f3e249f07239"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89612417f83bab0dc194f9de67d652979f60d00cc5666735c7fb4a216301db59"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2aa40656887e951d06374c9a84a1881c69499ab48f96d1697db089efd9ae5d"
    sha256 cellar: :any_skip_relocation, ventura:       "e1f1e7d0dbf9469285f102220275d78ff49c6393ccb20dc6c1053bff38731b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1c016f2b60a30ac593d1ae90f3862b8bdd37ff6bb41f238b0a20be0fbee8854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faeeeb352e1cbe066260aa1f25da4015e5b118f773dd3205d4ea53d60afde9b8"
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