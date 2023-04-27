class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://ghproxy.com/https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "3fd0ab0b3451e78b85bf2104d5b23b3c4d018cc8f2ed824e103761f8a327c713"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e5652b24e3da96ec9085d07c4b776b8fa8ebb6315bf5ce8c98361200d1f71b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e5652b24e3da96ec9085d07c4b776b8fa8ebb6315bf5ce8c98361200d1f71b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e5652b24e3da96ec9085d07c4b776b8fa8ebb6315bf5ce8c98361200d1f71b4"
    sha256 cellar: :any_skip_relocation, ventura:        "883b90c8117e35667b597728ceb2d23106ab6021fcd920055d85e6230dc74539"
    sha256 cellar: :any_skip_relocation, monterey:       "883b90c8117e35667b597728ceb2d23106ab6021fcd920055d85e6230dc74539"
    sha256 cellar: :any_skip_relocation, big_sur:        "883b90c8117e35667b597728ceb2d23106ab6021fcd920055d85e6230dc74539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f7c23c489737fd48d591e6093ab500dd9614706e8c98179d65273aad343a84c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmd/gaze/main.go"
  end

  test do
    pid = fork do
      exec bin/"gaze", "-c", "cp test.txt out.txt", "test.txt"
    end
    sleep 5
    File.write("test.txt", "hello, world!")
    sleep 2
    Process.kill("TERM", pid)
    assert_match("hello, world!", File.read("out.txt"))
  end
end