class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "5f74a30b5d63aee670cae94e7b6e4b9a009e425887c48eca2ae73ef4dac86222"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c673b08044f985aebacfccac7e4dc6b570cfd2075f490045a550723a4222c76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a165b0415a8a61f3e1a0d36ec32ef258ed36bc68a7b8b3f776dba932d3d7f9af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1dbb7c705ac93f3858bbd41eb276d6709f420f513b3ccdded07d3b76cf128be"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c9a9e4dff93a2534e1fa35833c20006cca4b24d06b3671a0ea9e1c588f60952"
    sha256 cellar: :any_skip_relocation, ventura:        "78fe3655b6b60298ee27117d52d684e971ae68f9a0e0db08b0840e65a3782efe"
    sha256 cellar: :any_skip_relocation, monterey:       "ebea43472fd0898a5a5a9fadc2a0bf88dbc0d1fe29e22914cbf1fb89d0267086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e35cad05496c73d11bfb03d6df81499ba2337c3985ebd6dc3567a45969707b86"
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