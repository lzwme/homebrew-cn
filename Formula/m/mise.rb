class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.12.2.tar.gz"
  sha256 "714bfbfccf6ff9dfe3bfc8d3c9de197dbaa86eaa84fed2f070017b69b37d211b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f35f326b5512a3dd244111a209b9bffdb299ea56c98f21bb30fadebb8fcb5424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6365633861ae4d10680f2c5be684babfe1adb4b068772aecd6379180b4133358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4947ec8a6289e7d544a336ebb6b1ff44cc8084896afcd9609d3f04ef17e2627f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dabb50854b51affc70f59faf3f38b3c7e2d092261f7204a64cc591ae6e7b8fac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f855317c325ce3959ecbc7564f59f4fa6ed1b4ce3784dea1236b231c0a5d44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af8e304bd6e64abcc51f01fb8622de6669b0a8f486a71f1d29d01c89fc68fca9"
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