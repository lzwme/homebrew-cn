class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.10.tar.gz"
  sha256 "bf70ee277a683d487fffa6492b218550edd3b88298c62f26427cc32c14beb353"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b9647f591ab179875b5f024802ad7da7ae46a8737413a68fd8e3c4a0c3944b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d063ac57c5fcdc8f8d555575f38c79617eb9e353bfac8ae20ec2ab1cc528a334"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b404ddfad4582edd98e55a94f60c0e84a83602c6e36c157e711964e3e3a7b54"
    sha256 cellar: :any_skip_relocation, sonoma:        "726dcaa04deaba853aa385f6a612d35194f7c395e65bb6c1c23b637e3da1a6cc"
    sha256 cellar: :any_skip_relocation, ventura:       "1807a266b300cfef7c7cc687b76e369ef57847d16058927939035dc984523fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c4d0d6eaf10106b69f3edea7cfb4190e2db9d42b59940bd8eb493344885958"
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