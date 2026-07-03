class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.0.tar.gz"
  sha256 "c2e581ac26551e324a2bdb726d6dd34356f865ebb4220d3998dc3f99de9ec42a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fe6c59c8d5686cb45c3aeca9f32e0317dbfd5d6ef9d814ffd476e530a238a0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c83c19d38cd003a675004e0ed5fbe11f17b85fa0b43b22d4dc21a3c4a3d30e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391845619802285b5ae784989000f9b8498a260909d80c0c6ce0a296f719ab6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b88a123d6b3e204386507813e2063e18afb0a033fe2301490899ce9984de788c"
    sha256 cellar: :any,                 arm64_linux:   "f4567fd58d72e701ffdc7d2983d7c8aaa433c4f4a49b85b51f469534c88a333c"
    sha256 cellar: :any,                 x86_64_linux:  "a9291be4869c4034350b2be115cb49205c38c26d032540bb075a3abb199eb2f6"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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