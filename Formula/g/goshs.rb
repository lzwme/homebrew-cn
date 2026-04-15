class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://ghfast.top/https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "fd2d7d3821e7c310234ddc0b0b649a10f5215116caae4a16860e7c13faacd10d"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e32ac7a76896f2470da8b018cb6ec2ddfaeb20fc60b8f227241d13bbcc056026"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e32ac7a76896f2470da8b018cb6ec2ddfaeb20fc60b8f227241d13bbcc056026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e32ac7a76896f2470da8b018cb6ec2ddfaeb20fc60b8f227241d13bbcc056026"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c19f326b9b7bf17b4dc42421542067ef5696744f42ca179c88d92f138f27597"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78bef5bc6d01f79bbba10f863183c96fc6436a5078c0c0b6d6efce9374332c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38c9410f9ccd71c2d9b5f8230b8ca90403523f584396846615b35f0ff530081a"
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