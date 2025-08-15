class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.10.tar.gz"
  sha256 "cc113c02147c52a222c504c10da3e136a65e21725a536fd419448bee2922c1dd"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1ade8f6f83eeadd6af3a0ed4f1de35f048ed3fff58cd04a1ba351b350d54d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a66123312ba10a03f74814a013dbb86c23036eca1659695e937191f2f7cf1d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "619c8b1832c059993d413939e6712894e04b85c41007b558a5641dd00fef47e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8949da69b5457f82df8a3535030f32b55eff16e6efc0a8440eacb9724d834bd"
    sha256 cellar: :any_skip_relocation, ventura:       "0bcc9e48146323b1a5a3c5d13504f43c8a8e06e2c479575b1d3d2ce2f744be58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd76b4da7b4e585501b31ab70d6bc685c79e6b7f9dab7fc5bf3c839875977dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dde1b9603b31eb59271bfe8c92655b21146f521c192af177caf5a402b148fbf"
  end

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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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