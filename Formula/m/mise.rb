class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.4.tar.gz"
  sha256 "bac571bac0c5e28d52356de0f0af645b257a48afc29dc7b68fa118b728d8ca2f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a1ed5dc7f5f9e6d6104ff2f5123ea3cbb54fbfbbfc5478224254c8d9132daa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ed13beb33a708b23944292fc6480737b66bcb39d344579a5e601a6af4099396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ebfe8717ca70f63d4a46b4db541c7f5d6abd87f4213ef18b814cb88d876896d"
    sha256 cellar: :any_skip_relocation, sonoma:        "37017cc8fcc2ba84d520977bebfcc19729191c11e46a4364c2afb0ef7380b08b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19fc2a163da62fae4ca896e9bfaf81a8b5575c6c995348d6f9c9dae729c24534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60a149ef1ed9f13e0852d5c915402e6b9d7fd5bfeb924ee9ccdf095e83bf52e6"
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