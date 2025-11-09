class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.11.3.tar.gz"
  sha256 "bc0d5afd944d90202a375169b4e2f26e772121de793a3e392f3feb241bf8fa87"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ae965150fe78b265ec7ee422f4621ceb859ff3eb2c41dfbc9dc854d2684fc6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00def49183109892d0eaf23ee546d8a3456ee6c9ec7f9855fe84cb900b275d83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b157996dc61e8d800844a7b7393d4ec644ae9b6ff7186eced70ce8d83339a01f"
    sha256 cellar: :any_skip_relocation, sonoma:        "00b93b7c51054ed0a079084c1c86a2829c79219dfd519d05f0739d6ca2e8a858"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b7f8dbc840bdc273368125f008ec963ec2030510e13a99d6edc57ee263b7feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76c4b0b7d10aaaa8ebe26c8c4503066b089a051b062543adabf7dc96df5d2f1"
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