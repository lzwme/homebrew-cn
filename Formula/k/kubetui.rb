class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://ghfast.top/https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "00b9d176f74ab702a91943a7016c67507111aa9723184dbad582cc207f270bd8"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6375e048e55054e1a79d320a0fef3801acc3a28f08b717d6db2704ccf922f00b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c126ae60f396ed0acc0c7c11819cce709673c4849783612928482478e60dc9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f0795b06df634ed40faca72ed24897cda90519c2f6bc0b7ed31e47b6dd71f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d1711f9a1869bee1891523e7655733824ec41dffe8e7f39f566982f6b4fbd6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "791e60fe23aabe01e6cf5468b1a66cd9539cc04edb2dabcb640ce1d9e7b16aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "427864d3152e3dd42d4d8aa5a8fe89bb8cc3656ed6ea0698f8a0a5df7e1d8b2b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubetui --version")

    # Use pty because it fails with this error in Linux CI:
    #   failed to enable raw mode: Os { code: 6, kind: Uncategorized, message: "No such device or address" }
    r, _w, pid = PTY.spawn("#{bin}/kubetui --kubeconfig not_exist")

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_match "failed to read kubeconfig", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end