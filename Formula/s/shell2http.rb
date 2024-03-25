class Shell2http < Formula
  desc "Executing shell commands via HTTP server"
  homepage "https:github.commsoapshell2http"
  url "https:github.commsoapshell2httparchiverefstagsv1.17.0.tar.gz"
  sha256 "17fab67e34e767accfbc59ab504971c704f54d79b57a023e6b5efa5556994624"
  license "MIT"
  head "https:github.commsoapshell2http.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5aa3b3d987491267e475439e28ed32236b3a5983ac224f037ba5252b0857406"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cebeaf54ec1a81eccdaa79a135b6fa47402af330ef4011785fa813ddb4ceb12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14b86f0bd62e111c795277d5b02a09960759be90f5a6aaa745e2546ac8270a4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "22c0f297ed31f96042fbd408d4fc53deb7e4a257fc9e00d5c24892419e10eb0f"
    sha256 cellar: :any_skip_relocation, ventura:        "b2664cf38188a0fab8f22804a6b82e9058e88b75d7ce2b4226c912885bfdf435"
    sha256 cellar: :any_skip_relocation, monterey:       "9ec711d670e18409cff61b8d40c06031c1990f13ef845d41fbedcdb22619a219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2924860684928b8e326d3298c72c447dbae5f7a7ab259e71bcf45e7906568ef4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    man1.install "shell2http.1"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}shell2http", "-port", port.to_s, "echo", "echo brewtest"
    end
    sleep 1
    output = shell_output("curl -s http:localhost:#{port}")
    assert_match "Served by shell2http#{version}", output

    output = shell_output("curl -s http:localhost:#{port}echo")
    assert_match "brewtest", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end