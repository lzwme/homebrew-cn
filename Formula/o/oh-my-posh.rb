class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.27.0.tar.gz"
  sha256 "230d84c311d55bebce12ae1041358632c1e87ee1d30ce4171bbfb4033e045d1b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c739d486d8af5e09fca0d29bd5946b9a15bc12c623367a10e933254f10295dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "212f43bb5f3037dbcd646e854f770d095c8c57f15ed6971baacbc83670f30d0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9e8aecfa2baf337a7482604a2423a005eed4a9611083146e96e048378fca1bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "8892a0b24954e5b400458b9dfe0f8194031b2fdaf8068290c22f6b58a3da467e"
    sha256 cellar: :any_skip_relocation, ventura:        "7d7f2efb4138d5f62d400eba78caf349425e3d0938813718342cfe8f6cdaf03a"
    sha256 cellar: :any_skip_relocation, monterey:       "46c68a8eaf3d76ec7cac0c0c82eb8f4f68702baefd5fa7819ecae7370f979446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db1e251e9ded45e1d8de1e49e3539f193f8eedae3ddb4a343077db475a36393"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end