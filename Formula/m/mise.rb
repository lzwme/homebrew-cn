class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.5.tar.gz"
  sha256 "01700562eaa2126705aabdaaaf88df64a9df262762cf3be42f3a7de455ffe9ee"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c771643d1f679cd9437db34e4d79b53f94e15a3a2e0effd7d64069a37dca3c7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4553bc71950471c962ceec5362eca3f44b47eb3e7943c0107f99fa6a92fc271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb8c11d88fff1c82dcb4c1adc8d022b0eb7429d80e2bcabaf7799bcd5113ba66"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbd8d507ba38b8eded656cd41a72754369ba9189aae61650ddeb65dd61cc1f52"
    sha256 cellar: :any,                 arm64_linux:   "9cace234af894ce90ba0224b43585aae5681de4bad015317dd058c7f9275a0fd"
    sha256 cellar: :any,                 x86_64_linux:  "07c09abfa967eef4a9acf8d766d231e2725d64d4b64458823a2dfe5a6cfd1bc0"
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