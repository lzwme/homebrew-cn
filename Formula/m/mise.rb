class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.21.tar.gz"
  sha256 "8bcfb21cf0032c0f348e9d06ddd4e6fae9a5cea80ed271e91239cc45f928d40a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5b382823993261e52a7d5bf4e3263554a81cf720e9ce3a5bb0ecbbf074f86b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "160219c1b18dac2a340140499414d6ee4b046884e9907dba9fda333f43edd491"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75be0e4fe3af01c41a0b0f6c4a227f0c275aecfd9629974c1433653410310e9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f990c145b947e2182253fc10c3bf8352f1024caa9c018c4c00ec70e9e5d09aa"
    sha256 cellar: :any_skip_relocation, ventura:       "462abf8e8297424e9e89e697e717f0670b6dc0359809f0fe294dafc1144474c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5829b920127eec828c6dee350390cf6047518ca6b5889ce4d24b53d210f3787e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c81328c183c7a995713f049f440a0ac2fb33b67ffa3304e920329fcaf1d2fbc"
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