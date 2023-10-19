class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "12d55f543d7fa26daa76f671987b014a2220a7efe557a69dcb1cdd9f80f10401"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c1b7e9a2c42ffff7d1908fe0686bc6ec2818ae1758e4b1a3f8fae34789b9c64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78fa9addc1ed9f8a6f72bb04834b4133f81e561d9d07a440ba396163faaacdb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "553bf28491c50c95bbd03e18512669633d4355296064858e6bd75245e394f420"
    sha256 cellar: :any_skip_relocation, sonoma:         "429325c5609a8e260d255326df190c11acb8c630fbdd3105fdc4e8466a9a9b5c"
    sha256 cellar: :any_skip_relocation, ventura:        "47fcd86fadcce804fa87f5c58d65664a30e93325ae9d2ba1c311ea98d7f0bcbc"
    sha256 cellar: :any_skip_relocation, monterey:       "124defb4873b662ea20d66f19de3a28f1696bb83152ad0f1d10d430def128b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35f725050e77b5552fb00b24ecf585571d816107e39763fc2636b9210f2e15aa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end