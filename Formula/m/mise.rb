class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.14.tar.gz"
  sha256 "fa471005b42d3f8ebd2891d6d315d283a487afc101b319e7740b916f47914318"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7a584cd549eeda6eb53192813b04a422c4b23ae9e0d9bf135195f622f5b4d32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b16874f477da8c292aabba8991ef8360ae230b37da655adb9350e910685a5e87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db6d9f3fba5a386d301732c2acfe411a5b3e00b997ef407621ab2956cb8c672"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a90e014af6870e04dd419882f35541c73dc947aeb4f576f094bca3e6a5d7d6c"
    sha256 cellar: :any,                 arm64_linux:   "331054b1c9713d5f2d5eb6e4d8329fa07eb52ad8ad0b76aa7c086fd22e1c1a1d"
    sha256 cellar: :any,                 x86_64_linux:  "44379bb64f7d924a73ed078a74c8c016c0ebdf0146699911e09f0c479273fe28"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

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