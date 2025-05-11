class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.9.2.tar.gz"
  sha256 "a7023da2082182df5cf5547601048e7624cf13c988068697ff07ddcd3dfa5e60"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc24e60f6bf8ba052d5016b91a1a2fd641109533abc6675981768bcc3fc94eae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc24e60f6bf8ba052d5016b91a1a2fd641109533abc6675981768bcc3fc94eae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc24e60f6bf8ba052d5016b91a1a2fd641109533abc6675981768bcc3fc94eae"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff9b6a366a6941c647d53b0ceff396013255716f4274471eb3c3fd4bd6ff326f"
    sha256 cellar: :any_skip_relocation, ventura:       "ff9b6a366a6941c647d53b0ceff396013255716f4274471eb3c3fd4bd6ff326f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af465f7c258449f1ae6c65227a87977cbc67218e12d0ace1ff1bfb49adb09430"
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