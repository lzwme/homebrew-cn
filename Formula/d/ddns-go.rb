class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.3.tar.gz"
  sha256 "8d12594cd7a8b77effb068181b1a6d0a378e6321b5e4c3ec438e415de5fe4039"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16956ed4255970d41d83be17d79b944ecdc8c6cb49afcb3495367585e9360050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16956ed4255970d41d83be17d79b944ecdc8c6cb49afcb3495367585e9360050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16956ed4255970d41d83be17d79b944ecdc8c6cb49afcb3495367585e9360050"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bce47bc8f98389d272624cfd8becaee2156ca31bab7302cd99fc1eca319f8ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb460af462b5cf33364150b3f441ac665c9281c9db2eb01e167c7e81320f9dfe"
    sha256 cellar: :any,                 x86_64_linux:  "c99fc87d50a91d2550103caf869e9d35619b3021e09bb3305369850b2a034613"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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