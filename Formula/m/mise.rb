class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.2.19.tar.gz"
  sha256 "d31eba449060281c36aeac702afc12ae4afd5dcf1635bd12672de96d5b27743a"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1610f786a2e66a2e77be375811e395d178f99af571c59e873f3ea438e232e395"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05a18b4105250a502766156b735f5553df63026e39d2e21317c1c4ec01bd79ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c56de2bf4377e92f865a7666d72f2ecc98b56d4f802ec49047c09027495dffa"
    sha256 cellar: :any_skip_relocation, sonoma:         "29e3ca521a954a55985e97ec5679c73c8274c5ebddcd6e4412b1f64d329531b2"
    sha256 cellar: :any_skip_relocation, ventura:        "34f6b1ca349114b38fa03368b3f3c90f4be5d40e7b8e69978d7d782546862d01"
    sha256 cellar: :any_skip_relocation, monterey:       "311c74dcab334a8f74818b18c29dbfaf8db6728998eb53c1cb6fb279d6ae4e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c776099ce9d990e8b71dc854084b31aedc2bf9695bcc01d2ef1d3f22f30957be"
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