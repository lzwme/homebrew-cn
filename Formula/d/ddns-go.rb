class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.6.6.tar.gz"
  sha256 "95367d8680c27a78024be339aaad77d73cda05e7005b8d9c342182e4f97c7bcc"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c59a14f24b91657de47cf290dc2b2763ade2e6906fa9559b81456fa4202911dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9efe8efee6fb53a30f677e758673b0aa2852ac71979375c1d531dda5aff83876"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3be207163a9d6a75a2935d5a4539dac2feac4694812005446fcd3b98964fea2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4191316c6091658599add429f13d17e0cdcb1f53a09897a967b2a50e1b00ad4"
    sha256 cellar: :any_skip_relocation, ventura:        "84657f3adde4f7a4b041dd58819e3daebe22c5637ca8bc4aa72ea900c37fce71"
    sha256 cellar: :any_skip_relocation, monterey:       "907ae55ebae7f46e2476ac1f2fa497fa0dc71ee2fa0f832d78435ddabe80a96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2c6ea465152e737b93a7a4602b1e078be196ee17b180ca50b47ef5a35d74404"
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