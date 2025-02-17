class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.2.6.tar.gz"
  sha256 "c2b202d22617ea24953a52b3455549e5d7c1b1b2ca744dd8d3a725702cb4f628"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2298493bb53a55c0c556bb776551a983ce95219c83d435dba31a9c3514f605a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df34fcfe7288e08716777a982413d73c98625afcbfa5374826e3b62078483b00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59ccce2a344b82a19af407760d9162fc4115975578f7dc43c5fbb6b1b35e70de"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8cf99cc9f09946c350f7d560286d64d3284871fd3a9bbf8f7e34a4d5390d1aa"
    sha256 cellar: :any_skip_relocation, ventura:       "243074355c582497e83503fdb47909c41d1e3672bb95f60b1c2243bc689138b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72af23a6d47759f415dbf347c88390ce8f9ee2d39b88ed844b462fd8ffc24a0a"
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
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")
  end
end