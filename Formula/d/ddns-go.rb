class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.6.1.tar.gz"
  sha256 "8dce0f8eea963986abee19d44296ed9263c0f1ae45173178804adec4846c5922"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4e0ff2edac03e85a507eadd4a4f583d868d5aaa4011d61ea437aeea938ca435"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad30f2caee4178c63971d1ccd7deed13d3a28bb158edf2ddf9e6970dc67ac005"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "269969b777ce1f942396e969a50df192bb964194a28f6a959e813ada668f39c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7a8d3c4206606434cd63d3c86c7b04c211bb5bb1c137a39687a984b54b9cd1c"
    sha256 cellar: :any_skip_relocation, ventura:        "61e9f078e90c7a9e04f8ac0235b8cb3e452cd4a01cb6b13df8799ad3c8505c31"
    sha256 cellar: :any_skip_relocation, monterey:       "4c354f597467afb1c3a839cd739bdc8d646ff9f9b24636d961a085a827f9889b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb6817f63e4a06d1ddae5cf6080234240c46ea4d2412a47128119d7e9e34f042"
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