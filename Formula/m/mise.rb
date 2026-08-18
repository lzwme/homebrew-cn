class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.8.tar.gz"
  sha256 "f4053c5f98801ea6e35fc0050033ecbeb1c5d6c2142b61e07abbc262f8cccbaa"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aedea21e25e7d322928d534e8c2ff899fd20460f671af652012775d03584978"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850bdad2f529e52e6e453ed849682e106daa858d6b30585c7d3156ac688360f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14a182fc0f0755a2c50bf63c2c68f33d0507336a27e13ac99a45f4ee3f2896bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "383a9e8861cbe73a29829afb36b88a28d39f313d47c7fc5df1c300619eb1a36c"
    sha256 cellar: :any,                 arm64_linux:   "f0535f357aa0c22f781c8726bbf6e79cb1c723011594c879e33fdec3bef5a2e2"
    sha256 cellar: :any,                 x86_64_linux:  "38d5577cca04342c65a25fc05df9549b9c059f1112e09977d205821f159a1489"
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