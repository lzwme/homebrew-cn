class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.2.7.tar.gz"
  sha256 "359970ed07d0ee41c4c5e778fa5647de4bddbec6087754f37ff8afd854ae35da"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40b01ded4de78e1bb74ed803f0e3b9a2daceaa4b3fe1e3994eb02ae40e930770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca49423d6414c5c609892fe7eb6550ce7d62b214cf95fe2aa9554030e9f94ebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ce363fa12c13439d7ff411d654f6217f7d7f7832a5365d7c51c3b4d60503b6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "35e2f99f70dcab066c2a9977b489fe855c1cf5dabcc0fec6fe4f00a64ffc7a7a"
    sha256 cellar: :any_skip_relocation, ventura:       "2e5607975a76d2f80158c3977316d2f2f0638a4141219ac70023b1381d27293c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d1b0222416dcbee283b5860cf40739c7ae5caafd452cac38729a07eceef1c6"
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