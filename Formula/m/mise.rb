class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.3.1.tar.gz"
  sha256 "ca1c8853792d28bc8b3ccbaff738199bcee2b1c7e7e09596800a73aacdd0c970"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4f43ba5f6654b5c29f4ff69782e9bab2595992d40929770725b7121bbb62645"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67abf5a6121f87200c2d8f6243e6d119ecc90a07dddf56e28d961dc4330d9dd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8de9789687e807b466151219080aa8f0ed3374fcaf2837a7540d08ea6d51ca26"
    sha256 cellar: :any_skip_relocation, sonoma:        "556e77183a006a016fa5e8dbaea335e6dc3096adde94232634137fc651328b78"
    sha256 cellar: :any_skip_relocation, ventura:       "5aea80dc676ea830071f37c0f0031bf263d9749f820d0a204d9ee9cedda03d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27956740d6b59be45e992a6c985334d22b8b15384354abfaef73f81ba3e12c94"
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