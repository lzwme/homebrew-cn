class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.3.11.tar.gz"
  sha256 "6bce862d0df0ba9bd509cb72dca6ae6944ee153985a3b073676c91014f87de72"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edb50cf9afb7be2119baab3711f72435d44cd48ccad4dffe008f02b6e7cb92e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f20871e71bddf21ee0d69b14755a26c817128c148cfebf86a43cce5ef1989c93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bed5ea2082d0a5b83594eacdd4613c12ca00dc5ab52638523eb934c7f05a2f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b6b650d60dffd800cc0e0e9833849926ff8de9e8b445e50b546a212ee2cb940"
    sha256 cellar: :any_skip_relocation, ventura:       "2ff55de14b22391cc77f9d0875ec31018156a545f879bda9532a181d90ffab69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f1fb2578aae454d27cefdfc94b5b00d8c93782b913003ea43493c88869a1b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3006c6ff3e43cdb27dc984d14752e679090bcebf38b77bbe1bf896dd7146dbc7"
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