class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.6.5.tar.gz"
  sha256 "6216334feff2e8b7ebbf48f4e2103e6961e83f38e8ddf58098ba4fd51882d818"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b17fe3bbf521321d98aedcd186f96cb354591219207c809614c3c0a9dc2cffcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac497e856c8f0f5dc887f74752906fca5d4786ec8ed74905518d832c6f926a80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b35cbb1ad8164bb8092daef507de288dd0cfec2be2d83a61a2f027efb2807161"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba38c18bd6a6995fd2de29c16e33dba9c1041d074d158c483ce572eea3801bea"
    sha256 cellar: :any_skip_relocation, ventura:        "8c2d7493b6a67cb71968168fc867650a5a7faea4787b28c6a4eb10a3b9a77950"
    sha256 cellar: :any_skip_relocation, monterey:       "b3e579619d49236b7d5827f18a570739a1a1e8ee4d5fff26f898312801f845b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7362f1bcc4d70d1703f2b1bb3948bb5297b83e54f23c58fdcdc473d6e79f406d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ddns-go -v")

    port = free_port
    spawn "#{bin}ddns-go -l :#{port} -c #{testpath}ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}clearLog"
    output = shell_output("curl --silent localhost:#{port}logs")
    assert_match "Temporary Redirect", output
  end
end