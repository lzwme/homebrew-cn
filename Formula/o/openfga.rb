class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.6.1.tar.gz"
  sha256 "8f6a55eeaa772c91034acc3d12d1f9627e178cfa744a69c41c16153d37283329"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e668039115bd9c7fec9205fc8f854e9c857de093c9d0722a183fd13c22daa1d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e668039115bd9c7fec9205fc8f854e9c857de093c9d0722a183fd13c22daa1d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e668039115bd9c7fec9205fc8f854e9c857de093c9d0722a183fd13c22daa1d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e668039115bd9c7fec9205fc8f854e9c857de093c9d0722a183fd13c22daa1d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4840d64d333148a606ee2f4d2a45d5bfc6b200ad69665422fb8798f98dfcf68c"
    sha256 cellar: :any_skip_relocation, ventura:        "4840d64d333148a606ee2f4d2a45d5bfc6b200ad69665422fb8798f98dfcf68c"
    sha256 cellar: :any_skip_relocation, monterey:       "4840d64d333148a606ee2f4d2a45d5bfc6b200ad69665422fb8798f98dfcf68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ef124f59ae21274279f2959926d8da99b22a4d031a8ebb9d3eeb75790f6def8"
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