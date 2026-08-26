class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "e41ce78e0864acb46862d573e1eef7f12dcf707f9155c17169fa0765a5f69997"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "530e14d0b75e4ea53af5a7c6d6a80a8a2b4d930a4b218b962e8b5285f317fda9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e963715539e407310db1e0ed982811f3247700bb97425c195d390756e5457f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddd5aa7a681b41d37f95f00a433517f8994cf619f351c0e12c2c6f1fa9ab671a"
    sha256 cellar: :any_skip_relocation, sonoma:        "35e5e63c567ca5b0cfb1bc79faf0da121f070dcde54ae7571c1e3d766bf84aea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e0f47d74c8a9578da90562a435120e37b9a57b9408686f4bba8ec82eea333ba"
    sha256 cellar: :any,                 x86_64_linux:  "05a824f93e362650dc5c3ae0e4e947e4bfcf06ce4580c869622228bf621f743f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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