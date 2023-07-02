class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b51efcc636f54445eb77089ddb0d2b9f22c434c008b09181cae65354e897070e"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5055ff5bb1b11060659f731625a7d5cffa2accce8157a669515a9b6756f5fbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5055ff5bb1b11060659f731625a7d5cffa2accce8157a669515a9b6756f5fbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5055ff5bb1b11060659f731625a7d5cffa2accce8157a669515a9b6756f5fbb"
    sha256 cellar: :any_skip_relocation, ventura:        "ff6cde8a80437e3c6c3673dcd45b6a581a8639d8f7d3b4478e15636a8d00283f"
    sha256 cellar: :any_skip_relocation, monterey:       "ff6cde8a80437e3c6c3673dcd45b6a581a8639d8f7d3b4478e15636a8d00283f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff6cde8a80437e3c6c3673dcd45b6a581a8639d8f7d3b4478e15636a8d00283f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5eb02deb871e6c698977ce82da52a15e5304c46c531699c1b52d27f19c27e57"
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