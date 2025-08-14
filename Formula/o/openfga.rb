class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "6ccc9909768930403bea6b16084dc48bf320da9976a3bf9943551bb03a0c4b9b"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc7fc49d495ec0d815126a690d2dc9abefa60ceae9499b4fd64a39ad47e0e46c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "724791eadd828cebdaf96bea63280be62056b16a41bdc33caa6f4b1066db9a39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6922f35653c444a93e9b25a8341df8f883dee0bac470be6de9e0982f9da3d33b"
    sha256 cellar: :any_skip_relocation, sonoma:        "add4cefa7a4633e95fe77a26a9735e7f3426aa05b91aac228388cc261fc591eb"
    sha256 cellar: :any_skip_relocation, ventura:       "43227408323df95e23c4f6b920d8140acaddb5990e5ccb9c0c91abf6338055b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d21969e54097bcc7fd811abce977807e5019a231f1940cd627783c236496c4"
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