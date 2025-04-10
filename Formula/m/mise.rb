class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.4.1.tar.gz"
  sha256 "755f34ea2b27b23db84ef4ed4cae1ff1afff1391b65d033b80b0ba03e4027d82"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b58662db10d093f2e8fd8bbca8978e64c5318de1cf43304b0c5b4cd411e156b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a740367b446189a54068217c9715c4185c4f65bba24357965a83e5e90e863d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c91c582f8f7ce3ee014fe8e49195e103d4e342d9f0ac75e4de8c25a0baf0cc1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed3bd9c96097dd3ca491028472595b1ee8f703096db287e6545c3bc1f03da34a"
    sha256 cellar: :any_skip_relocation, ventura:       "f8f6a5ef394674f915e67a357f364a759b7b31e0875ced47b8349e41e9970591"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff5af5f22e6ca6564bd386697122c8a2b6f86a0d2c10aa0633bd4c2d32e4c180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f912a7ca407e3ba2c6d06f550cc1b88288aa39a202368be69650475b2cfe8146"
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