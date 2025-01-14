class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.4.tar.gz"
  sha256 "e478188a3c5ac04485a67ead8c056c7875938d413c3e0404c2d324eb0c953503"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0d3b6b143e83c324b654f969aac59b94df403c0f31dc7569fbdbd1960ab0c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0d3b6b143e83c324b654f969aac59b94df403c0f31dc7569fbdbd1960ab0c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0d3b6b143e83c324b654f969aac59b94df403c0f31dc7569fbdbd1960ab0c07"
    sha256 cellar: :any_skip_relocation, sonoma:        "16255f253c9302b4dcbf5491351d2ffccbb013d3a5e74ec349398c2a575c10ea"
    sha256 cellar: :any_skip_relocation, ventura:       "16255f253c9302b4dcbf5491351d2ffccbb013d3a5e74ec349398c2a575c10ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2cbe45b512d0aa41f92b2ccbd0b63fb598ae5851aea142e19501f9e39383e54"
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