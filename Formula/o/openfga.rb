class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.6.0.tar.gz"
  sha256 "cc3fa7e1607484fd4640ca4abb919738c32d3c023f110e889213c3819398b439"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48cc7f2219b1209a382be446b0f5ddb3eeeac9d6ff528fd9f58509d9ed969291"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48cc7f2219b1209a382be446b0f5ddb3eeeac9d6ff528fd9f58509d9ed969291"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48cc7f2219b1209a382be446b0f5ddb3eeeac9d6ff528fd9f58509d9ed969291"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a2043f7edb37b6e50b44922546387be85cfa6664ce1971406334d50fde358c1"
    sha256 cellar: :any_skip_relocation, ventura:        "7a2043f7edb37b6e50b44922546387be85cfa6664ce1971406334d50fde358c1"
    sha256 cellar: :any_skip_relocation, monterey:       "7a2043f7edb37b6e50b44922546387be85cfa6664ce1971406334d50fde358c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02def6c16b53e1487a9418b35ba2521933d06d4be74844b549d527a3d5a1e0e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopenfgaopenfgainternalbuild.Version=#{version}
      -X github.comopenfgaopenfgainternalbuild.Commit=brew
      -X github.comopenfgaopenfgainternalbuild.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdopenfga"

    generate_completions_from_executable(bin"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http:localhost:#{port}playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end