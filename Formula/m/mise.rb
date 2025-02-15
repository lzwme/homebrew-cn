class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.2.4.tar.gz"
  sha256 "9f6b3f4fdd7f50e45e4ca5cbf855caf5bb91a2bcbd936ee2f3e57598f2d00ca9"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83b75905e474f9909f9ffc6377cab6e84aaa3787e92b12343db990795f0e8f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76311c2e688d137f9f76cf6c69dec645fd8ba5cdaf6135875543712ae00a1e7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e0b2e175fabe77c08b0a7e656b530aec582dfeb2fc88fcba3adc2fa3615c67c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bad7076990199d2fa2b52b9ce8ac6c7280fe4f7ff257320164ac2340083d7df"
    sha256 cellar: :any_skip_relocation, ventura:       "a9d8a57e20de48b1a35e80c147cb4040020e913ff1d18bb7cdf96df21ee9ce4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4636cae8d38b1239e6c862388c0c51205141ffbf21fb53f3447a173bc51038e7"
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