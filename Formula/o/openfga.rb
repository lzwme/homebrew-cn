class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "a24677d0c8415bfcc044d2f0acca22282dd2b35cebce5a9d3f425f7f0806f88d"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57cedfb1fba6a323b99105b031cd61c31c1002db373d057a84365d37aab05e33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e14edaa14be29da53f46cc153794260580d747fbc7e61cbc922f74b42bd1d2e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db8d6f73ae4db5d05e0836479a810f6ba9889dde502d0af199a3f3239f18708"
    sha256 cellar: :any_skip_relocation, sonoma:        "f79732654de5d7236a892a0efa28a781153d631625136fe5ac5961d2399a2734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c5765627cfa9ec30ea29fd0bae0b80ab71959a23c067bab8f3ce6917f833975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf507ec89c82119f8b8749130cb77b5b91ad2d3bbbd715a71673aa65e82dc2b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

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

    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end