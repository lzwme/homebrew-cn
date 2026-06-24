class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://ghfast.top/https://github.com/goshs-labs/goshs/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "221822c285bef62c1c6c296cd208aa77d7f334953cf1bb285393f94dd1db6f46"
  license "MIT"
  head "https://github.com/goshs-labs/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c719620f162745cc5b2424f773cd0e6538d8c5940f4cbb4289cbf31b689114ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c719620f162745cc5b2424f773cd0e6538d8c5940f4cbb4289cbf31b689114ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c719620f162745cc5b2424f773cd0e6538d8c5940f4cbb4289cbf31b689114ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5232f18312193b0ea2b97f840052889a5bdfe5c1a9647267b4f72bc53869894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0facc1807af9387ba96a33af038e34a94d97c8b1cd3bf025525dd59d95ea3a3b"
    sha256 cellar: :any,                 x86_64_linux:  "c890425b95161f1e99dbb99863e1d6c6236ec564a08625c66c77393e2ae5f74e"
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