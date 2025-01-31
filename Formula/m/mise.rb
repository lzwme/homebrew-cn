class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.15.tar.gz"
  sha256 "d3f2db473b9639e77f63e1dca462b7ca8b5a3fee8083ce7f196c1463745fc69d"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c5e89258276e7a45b21b05f75879af1c761ae1ba9e2d309f5b030e2e74bcbc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2efb7fac03646bd3d1eb292f6170cd5bde4925001d0de48beb1fd62eea1b7a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00f969830bc796411a0ce8987a43d8b0c32429a26ca9bf19fc21870fc2d6826f"
    sha256 cellar: :any_skip_relocation, sonoma:        "affcbdd7dff9b06bddfd1f29a53816a6af1b878fdc73aec8d3026f6d015f71b1"
    sha256 cellar: :any_skip_relocation, ventura:       "275bff5396fcec6d74cd8788d67565d1c3e7c083522da75f40ccd4433abed032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d56e910308c31f3e4a1310cb4958aff932db5eab392cac49d74e23eccaee260e"
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