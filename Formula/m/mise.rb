class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.11.tar.gz"
  sha256 "608a12c8243ce424c3ea70054d7bb38f638b189e5d1c66074d436aeb91e9a658"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba601ad7b8d9c7e5936db40f6fa485501bbde8c66b8fb9e599fc84ce4a827dba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aaaed91bb61ac51e393ce49f1e28d894ea847e594097e121f86993744783d05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e06a1cf64d89e74c66bcf8c5044dd7719c08e53723ea5c29d3e1d49ba36bf315"
    sha256 cellar: :any_skip_relocation, sonoma:        "90185b0951ceb4f60d85d89bd86b3373e7724efd03db924bf59d7826bfd8838f"
    sha256 cellar: :any,                 arm64_linux:   "ae887de9ea0e5f562f588311201242fabf64c75a4b2eeecb3e01ad53341fd6f7"
    sha256 cellar: :any,                 x86_64_linux:  "69b94e6620408dcf69b3283217b9972c4b071d52a0c1e8b961d93de68d70373f"
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