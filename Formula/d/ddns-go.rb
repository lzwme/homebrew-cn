class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.7.tar.gz"
  sha256 "3f30d2aba480b20605951b6bd7e21dd059a2b9804f270ba448aefaa63e4e4158"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98d8b5a4954912aa5ff6e666d4814c150a1a7e0b28034cc680bb974088624d34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98d8b5a4954912aa5ff6e666d4814c150a1a7e0b28034cc680bb974088624d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98d8b5a4954912aa5ff6e666d4814c150a1a7e0b28034cc680bb974088624d34"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4eab649777a2181a3e798dcaad67a5e59c57bb8b2bcd1865af1c902960a7d50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceefb4f5be99d278b0b2bc7609690cb9d896d4e76b8e6972e250a4081d9e6305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f80ec3fab36fdceb835426a14d0709d3d2bc4ffa0ad187d22ee43f4e6c51b2"
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
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end