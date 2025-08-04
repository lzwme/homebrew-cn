class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.4.tar.gz"
  sha256 "20fd1c91376305b0854f27f8cf180d3b0891e95da6b9967b6f5409b7ac9df6db"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5e0993e6db40a5a2e40de9ea6245bf1e13b5b80542c4293831034b59f87896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "978c5792a2f7492de3898822f2fb9dd576c660b679866c3661014924a30ab2bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "524247cf84963801f5d5d233909033b435405bb15c7195d2179907035d60ecd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae095b041a987e46a37c7490adde9b5794334c4da1f629c9cd553c40f83ae98"
    sha256 cellar: :any_skip_relocation, ventura:       "678b6e3e83a011d395e004dbdb172d81bca6b887ba67b6020f49f5da671ccaa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c29891afff933644b591d3fa4733400079ccfa7dd96806814c49b27f2f7489d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305bd89132e566173d0fa856d88c115973c90382319c0251fc48e7c0f9ac0c16"
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