class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://ghfast.top/https://github.com/goshs-labs/goshs/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "d32d7ef734fa4e98ddd0e1258243222a6b9604eef055a81dae4a5d482941e89f"
  license "MIT"
  head "https://github.com/goshs-labs/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d43559252298221e8b87726810576820e3567bfcc4f8b96d1b1abdde77d072c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d43559252298221e8b87726810576820e3567bfcc4f8b96d1b1abdde77d072c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d43559252298221e8b87726810576820e3567bfcc4f8b96d1b1abdde77d072c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d65420f606e14c5046b1b52e0a22951d94a786d69f8e0e1ba9ab60c54d8f474"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "448627b0ba660dd5d7ea8a30b3aa493976c1adb284413b09c6806e529bbde5f2"
    sha256 cellar: :any,                 x86_64_linux:  "26c858907d39eceb44ba473e231332ec38db6c60a68f14eb22812944b3eec2b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    pid = spawn bin/"goshs", "-p", port.to_s, "-d", testpath, "-si"
    output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end