class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.0.tar.gz"
  sha256 "eb2f8f924e649c71057ef5745ee8f52d27ef72064a2391bf5b90ef51a8ee0293"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29ffed50f6d58140e91362e0dca71a8dc62d6c4a5b02ffcb51a870ef889df76f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ffed50f6d58140e91362e0dca71a8dc62d6c4a5b02ffcb51a870ef889df76f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ffed50f6d58140e91362e0dca71a8dc62d6c4a5b02ffcb51a870ef889df76f"
    sha256 cellar: :any_skip_relocation, sonoma:        "54db5105c1bce13bb1a7a69086aac561c3c51e5189ad2730f229882b7dbb5d1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67d1a413eb59af04c3089dbf339398ae973b86934a495f6a13373daf0e6174a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2cbd818d1da4b7c67dd7c18a0814a7a284d728cd1c6f2154394d3d7f259f53"
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