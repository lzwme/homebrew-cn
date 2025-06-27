class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.6.8.tar.gz"
  sha256 "e51ef65a03e8da03ee1d2b75bd2a3715318a33ecef1223216761f6eaecad2cf0"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76651a7961cbb873a6f9c891bde5184b6e9ef831dd0f2e260f4b0adff770f043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a947d6f550c290a4f1db9a6b25683c30aaf46ebab4e17b100238221e0e1dd50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4981514810577fc9faeac1d87a0dcf84bed489433a3f9903c8a22357c5de11b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d6b38f8dbcdeebc43d5bbdcde7fc487cbed444849ea97b4d8417b650e82e440"
    sha256 cellar: :any_skip_relocation, ventura:       "7b28495dcfdc01a58f7e422f7d7deb649dfcb9ac26d5260748c6bf809f30807c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c30383e0400c8747aebd3a66c1d4ad86f38aab2e08dbb3738880d5c57ef4a88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28e0a037fd6c58bc24891534cadf4a7f7433bdbb9096bf7bfaa31259387bd312"
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