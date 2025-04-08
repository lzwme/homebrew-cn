class Gaze < Formula
  desc "Execute commands for you"
  homepage "https:github.comwtetsugaze"
  url "https:github.comwtetsugazearchiverefstagsv1.2.1.tar.gz"
  sha256 "ba2878f5b0ddd385afbe6c8b3fcf92acdcd722113b97e52d2fafc53ee3cef918"
  license "MIT"
  head "https:github.comwtetsugaze.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86b270f20437476abf6aa88f367b734e8176376cfd491bdcb83c657388b612e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86b270f20437476abf6aa88f367b734e8176376cfd491bdcb83c657388b612e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86b270f20437476abf6aa88f367b734e8176376cfd491bdcb83c657388b612e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8165d4fde34b016e36c5455ee3578c475e90e6e13e21f14f07e67738a4ffa4fd"
    sha256 cellar: :any_skip_relocation, ventura:       "8165d4fde34b016e36c5455ee3578c475e90e6e13e21f14f07e67738a4ffa4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5704cda4c55581a1a1c2fbf7e6cce916ad75276ac2bbde5b2389823c0c2f6cdd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmdgazemain.go"
  end

  test do
    pid = fork do
      exec bin"gaze", "-c", "cp test.txt out.txt", "test.txt"
    end
    sleep 5
    File.write("test.txt", "hello, world!")
    sleep 2
    Process.kill("TERM", pid)
    assert_match("hello, world!", File.read("out.txt"))
  end
end