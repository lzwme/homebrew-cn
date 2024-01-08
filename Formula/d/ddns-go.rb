class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv5.7.1.tar.gz"
  sha256 "6f59151f36fbba207d156a905c8de80e26c7b54be9da5d0821d3417204d0eca8"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8215bdcc0444f71c57c636a6176ec27ea542df9390de66bdac4827e4c73b276"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e0f6e36260535e25ee3b76b0c52a640040c6ececf366d359d4293be3c07a4c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e98d343442b8e432294930035f6cc56aca6d23dc5b8e48dfb979760b545afa40"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a6fc40d9c3f0fd2c8e7689ebe5d5d6b633ce66e06904b6120bdf7f6ff622069"
    sha256 cellar: :any_skip_relocation, ventura:        "fc2ac00307d6f3b0c8f4e0737a4a11e490d34243e06abce17bbadac03107a092"
    sha256 cellar: :any_skip_relocation, monterey:       "bee48900f8fa7294582308aef768d9bc17f41433effa4d8d3b4650a17b3ee88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b96da6ebb8c0b74bfef486518f3ea71c08cf55d1b9a50582295e4637783898c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ddns-go -v")

    port = free_port
    spawn "#{bin}ddns-go -l :#{port} -c #{testpath}ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}clearLog"
    output = shell_output("curl --silent localhost:#{port}logs")
    assert_equal "[]", output
  end
end