class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.6.tar.gz"
  sha256 "8b93e3421f11b3c1daaf8df6d32c75f5a785faf893d593e5a20358d340d6d051"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29cf90b037e6b686b90d92526104f859d312f916a40deb958d228701c8b9910f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c5114172675de90d0b271ac5d7153c7d42afb01a8abece0351a3cc04111c560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe1bc85c6aced86f88d3598b484e0ab5986523727750d5182d0a13636bb066cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f47f051725ef7791875128fc5e20713aaffbe51e90859df0868cc3611c91ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89de789911a385d4fec77a608aaad2badf9a8b5230b443ef55b55a62dce199f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "511e2fe0a1dbae709be5bc2f3f4b4cef35a38f8aec9176f0b76192ca6842a1d2"
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