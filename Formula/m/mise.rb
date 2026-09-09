class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.3.tar.gz"
  sha256 "1274a80f6ded33e7a12b2f001b883d9fd091ff34d99309fba01c8fa26b0d05f8"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04a785cbe67bf7e80936a85a8ead1efef805ec46e6bbc19b9261cbff424b1b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db88bbce26dfc0b743dcaa784325eb4ed0bce766b9de45508c12ed65333e21de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90b031ffd71c049321e55272e2f47d9f965694b14c584a129454a07e8ec5a4b"
    sha256 cellar: :any,                 arm64_linux:   "5b3f5d7f993cb6728f97bcbe9bd78ef65fff3a1a02a895f6ba0da37d2b13ba38"
    sha256 cellar: :any,                 x86_64_linux:  "04554038464ab22735ff9c93a711dc30b83770a4c6a4a44ea7538f644639221e"
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