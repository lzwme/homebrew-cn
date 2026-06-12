class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.6.3.tar.gz"
  sha256 "7672cac7661eff7417a229e2e7d0325a08fbd2730e09b9883b705dd669837af5"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55f9c3dd1473ec7b01e9dab6712d7e433f4dbf51b2a5523b7c55def700ad521a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "479b826b8fb73da5c479c3735e3bc8e192dbaede3d92c6a78f6755ef08c5a545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f26710c0ccb8c1b9160c8871681f662f2b923d01972ee2e5f76c6fef0e92730"
    sha256 cellar: :any_skip_relocation, sonoma:        "1da552af7dabe749a6f26502ea26e2a26f79b958c4e20b181f03a0b28d371691"
    sha256 cellar: :any,                 arm64_linux:   "6eda4d2351a3e1a511a804fe329434837eb2fd2ab02d34fcd76d2bf3de8f061b"
    sha256 cellar: :any,                 x86_64_linux:  "5a3c61de2a00f51121391c239d707e444c056e143df9dd207d74576cc17c3c0d"
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