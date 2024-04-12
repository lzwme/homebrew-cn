class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.4.4.tar.gz"
  sha256 "2ed0d6a3c74226e32abd51f45fc02d954e07f4b74a9fcfc2501f10d8c9d2cf5a"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a449cf51f2a905c356756d29d406df06b4ffc61334cef702d98c25f13464914"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17c82f96f53c7ca7e095f65eb690aa17b06360681acc53e0c8e1497644eacc5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e9b2c75002f59f13c311c85140ad0c90753fcfa1ad50c5606c41dd2a4a91ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "c14449dae2c823d1cd578d382ff2e47d5b55d03ed838cc8cdc72c56491de5b68"
    sha256 cellar: :any_skip_relocation, ventura:        "69ac38bf7daa88a8b4b1a2b0633237e18846935396151e7cd47690d6cc642a31"
    sha256 cellar: :any_skip_relocation, monterey:       "30263448f99e0390a5fe3a6947bf2c59b942051f53457ff69064f4a98b0e22c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d65038897c5d210d05c64ed24b1dfe443145eecf329546db4f7fd1e7e9e54a1"
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