class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.15.tar.gz"
  sha256 "4465fd0430d6423eba0a6a9cdacec0013ea1666888142450ec204e90b63a45c1"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eaff0b0e6923b53c135f00b1f31d2780da1cb9f1204ba058c6800ebd4cb64fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b50658b5ff62e40b302afc314d82f99ada127fabab9f1993e982630f075547b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3243760fdd2ceb9298171dd23b98bc39db031a8957133ca2c3a4efc6211010a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3cffdbc157fca934cb401bb93cbfc73f9001dc07aaf570512cb856ead8c14cb"
    sha256 cellar: :any_skip_relocation, ventura:       "2c97709672a99ca798cd06c700ae4c9c8eb8eadca333f883b7df309f2a73bc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b67a0e8b0347ecf7ed76a788896e895b6b51cd84366fed558e16ef7a16fabddc"
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