class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "ffc8da174b4f5090f3898dbe88bc2a0e47f2b78763cc61a4ec1a432b2faf4ba3"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70272d304651fc258f93882f84c416e461c52548e499156bbf63892f16e270b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9ab0910da540338edcfe415dec0a7a0eb9e4790298794dc8b32e6a6a65d26f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de0254f33036e4b26fc6baea4ba5dc82ca2f56ca8b3bf99cea815bbffa9709a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "503a07c6ff4aff7697ae7a3d1cb0c4f87639d8311b1e7255843c77d8412c7ecb"
    sha256 cellar: :any_skip_relocation, ventura:        "2de8ed142e247183a72a6ca23ac1d724a8c3891d36b4a9b9b610a641daa459e1"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d14c8e360c4fcc361d3e6cef2c930207b9ea31eb3cf278bd871ab0dfa521f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f5f90a7689da82b1c4ac3fdebd8c90363eb4aaba860fc42e42422920f9c8fa1"
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