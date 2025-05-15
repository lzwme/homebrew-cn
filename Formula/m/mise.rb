class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.4.tar.gz"
  sha256 "92e028dd7e9447f9f78196fdc5c9c6fb1c76730a29084c9ba54c039d85098f5c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ec90f9f6523042691d0e0658f6ebdf15a60555b12ffce4b1c9294c4f58e90f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b361c789445b2464d3a63bae89403ebec45b5e985e4e80dcc97fdf1063652adb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ddc3693e4204a80fcab80e8280047f959daee7e56b167604fae5cd67a782e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7239d74a63fe597a516259dc73a274379bf37d1a050bd28b9c391042c4dc607"
    sha256 cellar: :any_skip_relocation, ventura:       "71b37d02fcb66ce8ef995614ccc161dd553d47837d6e725baa133b57547b34a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ade226f718cb9f7d7e94f3d789cda57902b67c3332d4f76abc9f91680f18cd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79ff5325aea27c633c072c146e8c8356fd53df85ac430d67de1bbc3b80c8c46"
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