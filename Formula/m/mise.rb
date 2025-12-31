class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.12.13.tar.gz"
  sha256 "69a7c7e47ea7ef4d441652a04c4e7a52a7beb7628bb63d9eb963361cb85f5a18"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89891d9a0f50a7eae641ae52ac65cf4f20aea536dc7e93639377905e31d40461"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbd9a6b2c929fbad6bf082a1266cd2da937b8be27fe95c99d6ff5327973e41ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ac3bb05ed304e3dc0f76e6a4ff06ee9831138401c40de2e25e462f01fb733c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad6910b05be90744d99ac2d64eb5d332f8d8a761e3ae8d3c05d7a17ccb1767d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51879ed54d938eb8871deeb498fbd24cfd403856f025f3ca130d28dcb133d139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5e121ba931b0eac97d02a30aae19a7f67752b0c3a406d54222c318d2155513b"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
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
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
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