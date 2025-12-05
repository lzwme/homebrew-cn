class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "e455688ea9c923401b51540106770dc80a2245e3dfce9ba7be6e47e3988e37f7"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13ec06eb1fb24bab0c9a91cccbeb19b2d43e6181dac69e71fb14b758dfa1045d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72cb450dd81eea00f492cde1c6696b3871ebd5d56196812e291ea29684bb93a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f707043ba65aeeb56eca2fdfeab430189cbdbd7f83fb18b4393dbddb176ed04d"
    sha256 cellar: :any_skip_relocation, sonoma:        "197553e5d2727abaf954ef4eaf0bf59aa86b170e6dff6b289ca4f2e536f1de6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1e59b56b92f2c6fdfa5e07fae4abea099251722691f077dd338190100a2afb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b9bb6421d9c05a67bce6e3bdfebafbf199fc46e1d8e9420050f165699777842"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

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