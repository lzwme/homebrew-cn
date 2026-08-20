class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.9.tar.gz"
  sha256 "404defbcf11ddfe14133bbd7700f84a7c0658b90fcc0b2bce943ada5c496c38d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c74131ba09b4e71ba2fdcda6d36ed51e0f954e66bf4407f807e1e91c94e048fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7be3746a47c04de860c3dd1c040eb08a5f531d85afc805e433c79e345c68e6ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c95a3123e9089dccd483afa110161a17875d9fcb3dd2ffd5405b421cec6025d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcceaa97e80acb177eb82f69b9298a807020b91dd9073a01c1d02bb46cbaa98d"
    sha256 cellar: :any,                 arm64_linux:   "4d2f0cab4776890dfe1122b9902c54d7723e1db1ab7a5d925810868cec775cc9"
    sha256 cellar: :any,                 x86_64_linux:  "ab35ca0dfdfb4c3c2a1262af098ca44efb734957795789c0b071c3b591225ed9"
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