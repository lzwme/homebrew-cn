class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.7.0.tar.gz"
  sha256 "98725b8b9564010c3a4a176180d83a07fbd4f6a51fb087829b5e87eb13d27cb5"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df3430b35a16c032d735149be0e0372285b270f3fe826dec216dd7fe45f34cbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df3430b35a16c032d735149be0e0372285b270f3fe826dec216dd7fe45f34cbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df3430b35a16c032d735149be0e0372285b270f3fe826dec216dd7fe45f34cbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd06c3e9800ca6e57aaf25ea25b134584e1bc1a1a7efbda24c5b1552ba21581e"
    sha256 cellar: :any_skip_relocation, ventura:       "dd06c3e9800ca6e57aaf25ea25b134584e1bc1a1a7efbda24c5b1552ba21581e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b38267700278b18e67c80267d7b35cc6e3d0bfebc7a595e57402fe26ea3becd"
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