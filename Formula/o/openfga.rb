class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "02a6b227fef3c081fd052cece200399a1e18f4acb736719934d0e5831d4b4be0"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9d87b32bdfef307e22970cda0a077a662ea0f4d387bf8e1cd51ef63f3463dd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a80233a484198fad0773047712596ad9f678032dafbf4026db6ad5a44e857c3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc559ed178a9d668dd3eef7fd01fa82a9523d4b868a4b7204d03548b4583329c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff0b4fce8a82e3328f0fdba0b626c4bb0faeea12a39eef63c51cf15bffce270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a59b9747a962ad025147b6d7108c644d23982bba0d8cdd19f147d2addb2e288e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c29974c4a1f6f9982e8664ced6cefb6216547ccc18e5f6345e159f4d0bb1128"
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
    pid = spawn bin/"openfga", "run", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end