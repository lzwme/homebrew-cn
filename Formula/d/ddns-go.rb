class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.1.0.tar.gz"
  sha256 "892688c7b52d190db915b7bd100e37a0e10d5f98d1b7b3b36c1a867ccceab16e"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cf5e103f6e5503ea01a9c16dfd865099c64f7c6e9d58039e6135ce9353bb78a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18d206dc6d112cfafc9c4614d880896fe7a110e78ab749a8985cc62c829f4b70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e64cb0c442eade364c2c3e6d1d7481b5a86ec9a796beaba2b336b10196db6141"
    sha256 cellar: :any_skip_relocation, sonoma:         "456fb07d08e55c19384129c495fc3098a4a10ef6630f53a3470ff716ce534aee"
    sha256 cellar: :any_skip_relocation, ventura:        "519c0880a4fcdda790d4fdabf11c394c59b98872d861f3bec9ad170c21995638"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf51b5c6d07921c9bbdea1c14e8df3bdfc683b811c74294aa973d7d332835a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffcaa2e7dc10371663c6a9b2370266d4a8b918abd8272ad9bb5ce379ec0f82c9"
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