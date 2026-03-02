class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.24.tar.gz"
  sha256 "ff207b9c273e7c05c6154d68bbb74d5cca11c5deae6f2070abae8be5f4daab20"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6047f927a04f94c4fe261b033982234fce00b79276d3486f1c9d8d658a3c6ed7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17a83ef07fba06b6564359283c0e351a4290842a2aa954d190229e1ae384cd01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aee82d97a4341d6a9c23541100eae78506c574921ad4934c30ff0ddcd4aae82b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f2a83cba471b3069897f7c03b0e68dcaccc1e816b09c7a938cc2e81f2a79b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb540a5d82c94a598b966128d8fbdd6e813dbc1afc17a45d0f259ff46c8bb117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a1a63048e8a19632b038215df989d3020b5457978f59358d77b28003f9c5693"
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