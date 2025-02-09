class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.2.2.tar.gz"
  sha256 "9042137c960bd0548dc88f60018c6842a4f5367279ec6b22967a469c3ef7a300"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eedd8867b24d49070a29e739608519a790ec5f741bd272ba188753e0aa49b6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2f77cad2579dc24e881d9a00fc63e09a6cf2fd3497232153ce0ffaef38403e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1910d27f4ae297fcfd4f4360aa3d430eb74dd0f0aafe23d29aa7888069c3b64b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b880784030e47515fb5c37f669eeb879fbedd5364fc716db02ed2b897d426170"
    sha256 cellar: :any_skip_relocation, ventura:       "a56d9f2d081694a615663a3d074ee6065bc0d4b948a4d9fe2270287b32065c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca59d9c6cc7e965aca1c2a86d1d9fd668872cf4ae0060fe3b59e427103f051f5"
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
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")
  end
end