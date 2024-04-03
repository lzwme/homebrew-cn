class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.4.0.tar.gz"
  sha256 "1d25541b4165b1f5c5f4e90b888ae99761ee1c119467b82553062d80bc8c9375"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a3fff73670909858070c95cf10a732387698a98c7d60b03a4e50536769ccbab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "472768d5e8d859bbbd3cecd36a7413ee802b90f45fedb84f71b4dbb340d07433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a563afd91523511177958c7d561729f9474c30f8846f86007ece005598727d85"
    sha256 cellar: :any_skip_relocation, sonoma:         "44fcc37fb1724f3f34b9dc529334e898663d10cec1ba5f064afc4529bebbc2d9"
    sha256 cellar: :any_skip_relocation, ventura:        "c20b1d299bf0c2f1dff1bbae70536e2ae1d3b2132a5385dd96ebf94703ed4c64"
    sha256 cellar: :any_skip_relocation, monterey:       "decd4e931db0bc60204e91989a34b1a88a5905e5d856e249df7587f4a5d7162f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69304348a10986eec15839ff42b80e54a77fc3997edbb1315b302a8dd145d966"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}mise exec nodejs@18.13.0 -- node -v")
  end
end