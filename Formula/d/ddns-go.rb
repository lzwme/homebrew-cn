class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.3.3.tar.gz"
  sha256 "fee40e6a9abc8313632b29ccc9b71184a3f8f9377986de5d2773374ad4b99173"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9222986c0b0639316a8c6b8bce7b9dc8356945c9364553b59abeb41c111dce14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa8ad17727df01f184c038e17436507df1a1db6eadb13940511ee687cad75979"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "735e74b34d02bea91c4c8ebf8a03212d3275622e438ca13bd55f99ff346b27ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "d65e34d118f9c45bca33396da5cb370f11a00cd9287fe70f30cd53b6e3c0f4df"
    sha256 cellar: :any_skip_relocation, ventura:        "f41df71d5482cc182670f1fea613bfb2aa2867636ff8215d343ad9a5dd544633"
    sha256 cellar: :any_skip_relocation, monterey:       "4578a11e63eac1f155d671a30ab09fad34930c3e4df256b2f0da25fafe32bb03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05192412615ec99814a9a77a0bbc2011f3240ff7c007a8536df254016979bc64"
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
    assert_equal "[]", output
  end
end