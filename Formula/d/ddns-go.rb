class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.9.3.tar.gz"
  sha256 "898fbfdf774e1dd025bfe4c48b6b9cc6d4d16e8060009167ca3fae03e0e64d5b"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73adf995e17ecc2fd6de2aacf7fef175d7c728f5ea7de388b652cf94b6e4c96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f73adf995e17ecc2fd6de2aacf7fef175d7c728f5ea7de388b652cf94b6e4c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f73adf995e17ecc2fd6de2aacf7fef175d7c728f5ea7de388b652cf94b6e4c96"
    sha256 cellar: :any_skip_relocation, sonoma:        "41c375ee07522d2d70695b1cc486b37087b40148e1cb2ddf47cd06f4e7544539"
    sha256 cellar: :any_skip_relocation, ventura:       "41c375ee07522d2d70695b1cc486b37087b40148e1cb2ddf47cd06f4e7544539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38d1dded5aa1d95e9e6aa3757ba0fff6450f72fdf445ccd05d7c183fd10c6798"
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