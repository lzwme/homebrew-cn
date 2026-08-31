class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.110.tar.gz"
  sha256 "06bda29c3116353d1e8b23a9733d833ec053e97e725d37e2c6349eaacbbdf29e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a3d983a2a20dc91a8ee3d3fce6f5103c05142ca40a3a6f313dd5f2332f3da60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a3d983a2a20dc91a8ee3d3fce6f5103c05142ca40a3a6f313dd5f2332f3da60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a3d983a2a20dc91a8ee3d3fce6f5103c05142ca40a3a6f313dd5f2332f3da60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e103c9c75b110bd97217764c58bb7ddb826b325e1a747a96d164a36ccb795be"
    sha256 cellar: :any,                 x86_64_linux:  "171582c6bc5aac84242b49f25b785a32c50d0cd95e6f998805a6a9820d2a74ad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end