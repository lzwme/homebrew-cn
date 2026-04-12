class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.9.tar.gz"
  sha256 "841967ff32a8cb13f634989df5b5ea484fe98d295cc73c0a98ad6b86722ebf2c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11c411a0c058bc00949be270ba73b84e3801fdbc43224224918730db3f4e7ee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44a95ec8cdc5bac42c9073cd472500c2cf2595ccd39c87b067da5809b6f2834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d464c1365810053112a3813c9133a3bcb181ab85b60c19168c36cc8d4b4e69d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "129ed7f60d87336445c1c808be9a0597db4fd29d87dc0ba05e8ca7c8ce386541"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d39bc3d88b8b7d97d011d5ef4760fb0a17f8e988398556380115121930a8ec74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9c64ddeefb5766b7f036f63ab97a1c836912a542df3f7d277022e46d2b55705"
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