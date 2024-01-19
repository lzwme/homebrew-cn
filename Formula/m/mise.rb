class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.23.tar.gz"
  sha256 "487816fc2fd8763ff008a020b707df6488e126e8be9cf1f6cc6e7b7f31fd698b"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "742175338e4f2a8a9a4267657e4fa80477c4ceed42c822efd223c032d913d033"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceef2f114d344698dec8406524c50085fd2f40fdc5ad34debca49127fe90ea94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f844394dbc2014d25a011e2fbc23e6ac5c0eebcd439e4cdca1bce93994f08e08"
    sha256 cellar: :any_skip_relocation, sonoma:         "e29f0d1b320332c966daad25e2b6eb2ea213a7399fb80565fe70a92b9e0bcf4e"
    sha256 cellar: :any_skip_relocation, ventura:        "af63f9e5b2761e47a3f1a3db1b0b62ec9b53499814fa67488e45f05cb35b0851"
    sha256 cellar: :any_skip_relocation, monterey:       "436f5a16a5654db4b9185da7c34b029b6656bd315eee6da786440a5f1847d919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3481c7dab96b2304d7a12e407eefbde3e2cad3fcfc667facccbe4b4cede6dfb3"
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