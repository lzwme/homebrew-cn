class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.7.tar.gz"
  sha256 "df39fcac2584c759e79010748bd6df484cb388d9c62397ab709b191b46378894"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67f3bdc1afd08b12e6ffc9b81eab17476b7f9abe0bc8cef857b7cea221abcc25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38b6980729651fdc3db21307fc092c93364e526888a3a50c821b856fe5a09e98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5278bbad1cfc7e4938ad8122b2b1646483500d1c7d6def0080a5affad312c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8f057883364b38d59e3031d09950438bea62afa3f6e1d0e411dfb46652d4075"
    sha256 cellar: :any,                 arm64_linux:   "e62de3daa61f97c394de66699c5e649474c167b81f8220884aecbde8c1117ac0"
    sha256 cellar: :any,                 x86_64_linux:  "6196a2d8967fa577806cd7c2da879dce43fdd61ec86918104f7f6050b2db73f6"
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