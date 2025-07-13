class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.4.tar.gz"
  sha256 "155d357c729459baebc2526f1813ed6f5e8d7e954c4fba1585067e86992b7af5"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f2f6121393842cb42bff2f850c81136b906ccc88a085b3867109fcd01000f6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ae7b7d8e1a3b1ef0001bbe1316fa7d8f335a5755efd562e5b1c3642c954b0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea0906974f5d008b65908ea290b2bb6df90ee25186289574d68cdf2a020acec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "655e768a5939fa4ac2d6638b18f5fb5fb7893aa7f91c1794977349f48a44835b"
    sha256 cellar: :any_skip_relocation, ventura:       "222395a790c55dbc6c71281685984a00364749b0c9c623f68a64e720faece0d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11e2992c35bbf1b0455b43e53130bfd6b71995483c56426b01b40289a9ec562c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6023f030b00913bb235840fb0b513ea437b266e4eabf0917cc9d6d6ff3f170f"
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
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end