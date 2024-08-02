class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.6.7.tar.gz"
  sha256 "a2b8625ec499cfa822924bf4109b74b362438c92a7c632b7574817de8deee744"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96cd2f383602f134ffe49974a52cd4510d6b518eb30219e6657a7c158b77c32e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "380a791d710ea5aa8a4b351bf2169e984d717df85602cbcbbdd8506dc623c68f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54ed4a902c1124661a04bc100814dfb5963dfbd03c8311f9fc4aab57136af932"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eda11dab642faf505565a1af097e397755269bd24c5583ee5114f868f12d206"
    sha256 cellar: :any_skip_relocation, ventura:        "df0a305c35dbb02a8a395854355ab34a1932c8e380959412165ac65d3fb74ef1"
    sha256 cellar: :any_skip_relocation, monterey:       "e4da8ef5d21cf5e803e2faca5db665d610ef41f5a7fd2953493a70c7a5a33dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b911c36041904674819a15df476e94143413622406c703cebf81fa4afb54ff8"
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