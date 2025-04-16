class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.4.4.tar.gz"
  sha256 "3dcd68d05830fec5da392a99badff9133db3eb30e4b8470623df15f9b307a7f1"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8466e64bc59550bc94b259d47a2a079f7757137e393e1b91e3d1f973f335a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eca753f3707460f776af73364026cdcecc3ba1e565217f3d0162cb689ce75aee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93d7ae7e15db5b8133422d873df4e71621d8fc48c42c2fc27e4936c9f8e46ff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "64f903bce27adebebe6e246ccce06c1462c3dafbe4490beec787ff631c804bb8"
    sha256 cellar: :any_skip_relocation, ventura:       "e388aa389fd555f06525ba680832f1382497d5e54470443dc85f59bd53995020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "321ffb71a34b138079176583b5bd3deca3d9b39040d285d002c10b46d5830d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7860fa8442c49dab5c49a0d9a687a1fa18255e3ea620ae48c6e659f7852d873"
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