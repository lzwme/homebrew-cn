class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.2.0.tar.gz"
  sha256 "f79fe7c35f06ccd64c65b657e1f73fd8e0679ab0e63971a6a1da5611d11a4678"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec6582a625e8c9ef6fba758d64ec3ff4d39e183552c01bb62cb3cf0e1cbf0248"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62c13dea75b3ee2665828c010135431a32b7544bdab2a19376429e400c7c41af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb075aa445f2e17215cea970a49a15773be500e62d710d65b838a7101fdec3d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb5d0dad56cc4a8f36390e7e2dcd5a3e2cde2caffbe1b37558ed24f239a1b263"
    sha256 cellar: :any_skip_relocation, ventura:       "121bb023a16240c1254a04e68152bfe54b68e70a6917d19852bc7ecca0ba48eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02b312eef65fc0048d01fbbf1bcb887d57c31f72b9f6c4c48c6eaf42d7b3a10"
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