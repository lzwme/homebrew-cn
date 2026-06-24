class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.6.13.tar.gz"
  sha256 "4e7c3fd333fa0bc94e574a20654545b85406e33285376572246bafa6927fac51"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7667466a2f77077c1bdefdf7266f7adeb139d14de01d7d1855d6aa0e1cda6c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bed3f7b888c698bc7d056eef7b354cf188b8d12b5eb44f7199accec7c332828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3f77511db704da7d117e32821e3d54580fa4c4ff054ca08e3a64791f0c391a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f00453b454932c2fa41192ad037715d8a96673b6f1d8ba2f779bb784c7cb903"
    sha256 cellar: :any,                 arm64_linux:   "6afa79f42d7484a91ac57239636de84c627d5eff6f081162d2bbd6ee804ce559"
    sha256 cellar: :any,                 x86_64_linux:  "ccc6a369e23ab0ae87a334c50fa7e864216d3d53581d8d70b6a370f5df15d47f"
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