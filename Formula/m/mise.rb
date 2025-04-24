class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.4.8.tar.gz"
  sha256 "10578019016503d1232021da8093a7d641d18f661827dc1a37bcc264c0582dfc"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ffbeca2306eeb9943a2e3c20c0868fb0e3cd73cfec0f74e9a8d5afe9ea3a8b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "165d89c7715e5c893d72aa19984c2a5e90abf9463bd8a8054d2d3d82ca06bbe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f58b0290d6eba26019b4084e1ce256f9ed440d27bac1897dea7e7dab4b083a16"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc1da2b1f65e4f9735096a2d75784c192e901c338153e413b7c330d020e04759"
    sha256 cellar: :any_skip_relocation, ventura:       "abf62e278d0dba823df9190d955bb0c903f7a899fe09329129a180c6ad2f472e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0d34a3985efd348e8297cf26674603f4f447a8044e49c121dbd62430f69336f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cc73c81a984336301e3275cdbf2ffb4678180352c7061e016e6980d3d4b6601"
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