class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.7.3.tar.gz"
  sha256 "3edaf68505df7188e57ad89c1fc66fd7c2918e36017f357953fce4101e493424"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a473955cd3cc353806ceabee6d2f6078590f4f683a301d8a8f67b4df3fd5c4c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a473955cd3cc353806ceabee6d2f6078590f4f683a301d8a8f67b4df3fd5c4c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a473955cd3cc353806ceabee6d2f6078590f4f683a301d8a8f67b4df3fd5c4c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2836df7b3373ac072534497516596bd177e421bd8cf57fc0ec658987b83453a9"
    sha256 cellar: :any_skip_relocation, ventura:       "2836df7b3373ac072534497516596bd177e421bd8cf57fc0ec658987b83453a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c9797c1dba354f3b8d257293fd48e8326aae75699872f4fa48187c7c897318"
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