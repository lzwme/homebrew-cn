class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "9eea20d79ba5be57348deeae3220f707d0cfa395a73410feb86f931f6f77aa8b"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf50bb933b4d81233924bcb2e7036f473d74aef4db54e68a02be3075f33e1333"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07270fed64fd38af48165326112c286f3c29d6f03544fc78248286eb6fa5920d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48d5c5ea6e59bc15b71c0ab3dd852d5f8575299cb5aef6aa35c3eea34c8a32e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b22b885ee408b346fccd3ad17e7e09ea9efad244a9b64e0d192d81a6c5df4533"
    sha256 cellar: :any_skip_relocation, ventura:        "3f6d4b3ed6daa1728cf285908889d392a11c9dcb1b113e8e4e8d28da8995f7d8"
    sha256 cellar: :any_skip_relocation, monterey:       "01b73e27cab8623f6fe7ac53a0648147c5c0b88aa663e83b0b74f2eb82194ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f86a4e7850409d2b9be53038f02926f39544c2894314337d21159412ea1233bd"
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