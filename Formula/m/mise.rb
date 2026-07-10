class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.5.tar.gz"
  sha256 "51a980970caad3f7db89135ded8a6e91d8c95eeec02b6204d29404580373b9db"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2209e7f91a8bb447847a158726d8c829e2fc193cad3826ecedb71275c9067fd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae8859fac089a72b16fccb4d422d3ab338a8a8bf548670b9b33372ac9c499096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9befc4a3b2d98fd38028402e1489255b19f243fd2a3745891287dce7a3c84b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "d89df34b61619b5b6b287e0904f0bd11a7e2404b4f52643300cd7dbe1a828f57"
    sha256 cellar: :any,                 arm64_linux:   "69ee6b4e83b7a88883fdfbf6e52551ebe7752ce8db21b4be8c9fa55400de6c5d"
    sha256 cellar: :any,                 x86_64_linux:  "eed41014424336e30f78f8389a4f05d02305cf58357311397bd405e6605acd5d"
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