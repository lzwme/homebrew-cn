class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.8.tar.gz"
  sha256 "d4650cab3a8dcdd46303fc6dd61d9318b8016ecf27ea86a1d14fd52df3ee7b8e"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2522335f98d188829bc4f6f3f4be8d34d56ec6ec140aca9201e50a8d43e24445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a91c47b35f4fc5873c62053bc1d61cb5c6762e0eec9da126ed0ad0c7a1dc330"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d6289ea18b8c8f4c50b0628f12bb2913fa4dba066ad16ea9e70d4bcb79ec0ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "6557689b9e1b5db0e0df3e23d52361dfd56235f34d90fa08a0d48d1d5a255647"
    sha256 cellar: :any_skip_relocation, ventura:       "ea9b2dae709363d0fde66f915adf574a8e600303769b02508b1a2348b72f672f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a24e921db2a74304a170c4e4390084555277cd7361ed64ba63706636fef6503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80c179a11e6dfc4d7645c837425cc2f9416e9991d71cf051da23c73faf5bf49"
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