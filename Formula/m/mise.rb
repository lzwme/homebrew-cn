class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.23.tar.gz"
  sha256 "38e22356df6361a56f1fac7a151d06774d835f2ea9a0bf5a86ab369178d62ad4"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88cbbed941aa1a31835d012933c128d552123c970f65416ce2e3dc8c2e17b43a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "770622fc8fab76c82b570c41e920766a2096969309db514bba7778ea9000bedc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b9d2b8cdfbb6da23a6ed134075993b2169c47da14e0297f374c72dd9ac6309"
    sha256 cellar: :any_skip_relocation, sonoma:        "38791dfd76c18550d9971495df4f2b23ee8f6d45488307c056448f8871864b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ab66ecd292a1f980e13108c9baac645ffbee78474c1eea110e28fa9dde963f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0edac7fc8e671403e1ea8d695a2700765ffe03d2ed13cffbb212b63cb266f761"
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