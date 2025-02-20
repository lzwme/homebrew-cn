class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.5.tar.gz"
  sha256 "77772e2b4840da9afd824aa623e5563700223f290d05692e42b1e6cc0f10ea7c"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a22a7b3bbbec3b277c6edb919a6b95d49210b02769b312a589eb9671f1d838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a22a7b3bbbec3b277c6edb919a6b95d49210b02769b312a589eb9671f1d838"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43a22a7b3bbbec3b277c6edb919a6b95d49210b02769b312a589eb9671f1d838"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1eb41a60d437fdb5da7e9694a93e159b280d68eb9e021c377806ebd672c6af5"
    sha256 cellar: :any_skip_relocation, ventura:       "f1eb41a60d437fdb5da7e9694a93e159b280d68eb9e021c377806ebd672c6af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4d85792a08331b2edd6e3a8096967e20a6756b1b5e2bdfb99f4db8a184dcce"
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