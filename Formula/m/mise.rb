class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.11.tar.gz"
  sha256 "d66b75b0a02679c2bc4dbd41ebeb36c6ac861f0f6717491ec7cb120a4727c200"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d657cf62378cf724e78d684d49b3607f60bb8471966f37e4547d9d825c7e1395"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a4342dc53d5bd05032c5f53ec3f48bc391c6b815c0b666e7ce5e30f12a4d1c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ae892d97deff5a59906ea712fad4a66120dc165aaff0e64e397714c7e8af7af"
    sha256 cellar: :any,                 arm64_linux:       "36fe0715f7d87e6f52b43572dd9755060cb7167beeda4f29c751a69fc3e5745e"
    sha256 cellar: :any,                 x86_64_linux:      "fc8c4cbb32a349b5bdf6a1d2905d2ddfe94ee401fafe6b407d54d2fa72900dfc"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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