class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.10.0.tar.gz"
  sha256 "920976e933d94c64989d498a91333ab8b1d00a05307f00c31785c4cee89fd1d1"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cc1a078860d5ffef5ccae872b995f1a983c3621d9c359dbd2bced2e56a26643"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddaaf7b262c569c731968bdc3dca442a7fdb2cfba958570fd93af31e243d19b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5738440ca900a6c104bf2281f877ad7577432841914cb97a7936e5caa6cea817"
    sha256 cellar: :any_skip_relocation, ventura:        "849531ae6a1a304aaa10afd7babb43ea30dcf44900bc1a8277ad20e1ee893851"
    sha256 cellar: :any_skip_relocation, monterey:       "45256edba83de61791401f5b4608cca1ec3c3048ce56059bba52bdb932919d26"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c421a1f9bfd64d42c5af5ae0d78b39ebde92c35759873c1e2fe85c4f90da4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0174248e3a8e66917d2f9ec2ce532502df037e38867a3b3e7a959c2d27abb74b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end