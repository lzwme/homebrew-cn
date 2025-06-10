class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.6.1.tar.gz"
  sha256 "7b8f35f413b642f8cdbecd4e09c5817c406f308e0a9b8bde21cd48919f8d9a14"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f697af67d53b2ac0dd807a28edf85f4e53a04ecef1e336582550b4d298cc33a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80e4a1b46aa0c417d0106b87dac553db09b0f013a21d13733db7c3c9958ef537"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3428ce357ac0eca7ee2ebb80325540e1442647e082e2e451de62847ebb920359"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec3656ac9bd70619cd41795f87abf02511c545b39c9d309849eb1be5b46e0ecf"
    sha256 cellar: :any_skip_relocation, ventura:       "1b4c7d3852fff3c5377bcfc38badd383738a45b2f9ed0e41ade67c152ab76da9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1883e9150d0d3eadda8f70bcc558caa1035ffa4b7a969176cebfbe0dbbbacc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ec29b65ab1774471eeb8ad4d1fecfaa0b8bfba8880782b14df7f843544215aa"
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
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completionsmise.bash" => "mise"
    fish_completion.install "completionsmise.fish"
    zsh_completion.install "completions_mise"
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