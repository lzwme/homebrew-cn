class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.6.4.tar.gz"
  sha256 "69e90cff0be0cc7968a884109209765cf4d7de346cd13b7e147f1a0f332b63ab"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f9fa4263c07e645a9a4c7f786988bf2ab7aa3ca1a5ddbb2365f4cd54a825a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f224aaee9c14bc9755c2b07688da4868871a7037fb21ceacec858cce3550677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b855d1f577acd8ba8f66f2ced625c6235dcecc7e5ceaca8757b373a5135b900"
    sha256 cellar: :any_skip_relocation, sonoma:         "85cbc440cb5ba6c7f7125fa183c22717653e29f0569f0b27dd5ebf2c7727d5d6"
    sha256 cellar: :any_skip_relocation, ventura:        "f6d31760b85b0ed2b53d8bf396ecaf36c1464856ef943389ffffc0b29535b6a4"
    sha256 cellar: :any_skip_relocation, monterey:       "475583f227b77868ac8488432c04e8f6fb8398875d7ff88dc176257068607181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f121ff2b1a4a02966aa037a567771bce6197add980b08d36b5bbfa7b7836258"
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