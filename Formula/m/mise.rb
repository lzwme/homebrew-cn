class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.1.tar.gz"
  sha256 "835820146528779b4df3882c13432d12c96706fdd5e85a8af9fb84b73dc4205e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd348421548590096d5cd4403d9624fb94d169ba7679f0ff8d555571ed49f3cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e45973885400fcef05e42f629b469109c31fdd26117c083d25e4c8a3a41122c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e6431549305374a6f9b4da9ebd9d4712e06b6af545964a909fdeb585c6003bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e83587b4c9ac0195ad200b31cc621ceb288f4b46e5ff4a5adbfbc0196742567e"
    sha256 cellar: :any_skip_relocation, ventura:       "fe985f3e01fdb1476c54a95022d9cd2a98e44ad5ff0cdeac20c7c95d1eb50e4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56626f40ce3805f96ebc07464996fe876d7a30bc74bdac6736df5ad6eaebc892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d94bf4ae16e36058528158a577e0485320016014e92c28c82c6391b231639b8"
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