class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "8cf388498e9ca7c22539d2e838d986edafaaaac548454e7ee376b94d37878268"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "280c01975f403f92102849942aeb37b53b06f175fdd0f5b99e9f55a14afe1983"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c833f778145bd807d9e89655c8b7923f8309ce7d73fbe3a4d4df49558f75bea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6784f4f28e6161fcfae9b54a30923b0d5d9293a1a03dd5339ce92ee2497674ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "32a36bb62b566eeb739d15eab78ce520b42efdbd4a04b37e6c9aeaa89b42a6f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52c2ab26e4faf553fe1e52162db7b684bfd7af6c5f5da57db82ce49e4a17a7a2"
    sha256 cellar: :any,                 x86_64_linux:  "6bc3e787c4645c0e59c60a95b6f06c3ded7038ce443a05472448bca65bdb0cd7"
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

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-enabled", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end