class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.14.0.tar.gz"
  sha256 "684244194035a75f2830c57c6e0e1f4c06a0ca55d2f707acf06eaf6e0162f372"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e67ee969dd11dfcd576f5f42661e8fb20b813be49ecd175e99909f0165762ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e67ee969dd11dfcd576f5f42661e8fb20b813be49ecd175e99909f0165762ca7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e67ee969dd11dfcd576f5f42661e8fb20b813be49ecd175e99909f0165762ca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0499abab3a602b64fda902bd95ea0e79445c8c940ded693a7305494110228f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cda236ce998e843581005fdd54c9879d2e2d76ea3e5e445d6cb28053358188f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5047fbe2daaba971dbed3d1a36731f771028e56e7d05c21bb13bec34f920375"
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