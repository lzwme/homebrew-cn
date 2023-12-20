class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv5.6.7.tar.gz"
  sha256 "e18969811d09a93a7ba80a58b478130b56a5e6cffc91181f4e93bb912833c93d"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdcf80f1b580a8d11727fed7675dff52b7bea346180bc5f53829372e45ca2567"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dec275b45b90f63076d6926cb94a9d727d76348c69de962d2dcaf8b8d75d4e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcdc00a177fd9c156a5303ad70556bc3dff7709e6f07386a5f7a5c544388e000"
    sha256 cellar: :any_skip_relocation, sonoma:         "92e5a7a32942a4807ff8f25040adf71ed4b1b5f6a1b085ad246d824a5820686f"
    sha256 cellar: :any_skip_relocation, ventura:        "4d00c4b85117d7fd105948864dea18c8bbf785a3a0348a9db3ead374af34d111"
    sha256 cellar: :any_skip_relocation, monterey:       "93038a5b5af7b4acc6dae55cc944f40cd36bd3582128d85a6b6d3ea0b79070b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc3c315b8773815bda55504e47fe38adb6e6c8c722bce184462c12ce1a3fc141"
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