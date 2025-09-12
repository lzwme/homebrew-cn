class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.9.tar.gz"
  sha256 "dc78eb8e1a03ab8c603a464d0b95b7cfa606a2421c739d4ccced89b668875b39"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acf22faaef77594e578bd0e5482598ea9f100d47823f087b6803ac38e48b53c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d31f8b28a99906f98e9c34ad561481445d11b11165f08a57191f326063719b36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d24455159cb7580549aad2d9cc5526a9a1bdc2c593d07c85ff573192154d516"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c30e77351751102ea81774a4ae1754a53c41e0067a2091f6d8e63f864fc6c4b"
    sha256 cellar: :any_skip_relocation, ventura:       "b0526224b7189445fa6070555ad47a4868403ad55b6a8f17ca9de868c378e00b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc1befb15e9057b79da23c112f9da68280df7221d71ec40022b5902a480a6508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15cc5694f6d022f20191e113ee20ead7af024abc078d1fd22a10e0e994b163b3"
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