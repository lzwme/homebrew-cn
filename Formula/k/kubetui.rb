class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://ghfast.top/https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "a0ef5951c9d3cebe3712bc6b24af81f74513efbb1f3026895a027b2c71de839a"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5c65e8633605afb2c5dd2a9c194afa8d2ca9b2d3006966bf3b80e00fd88018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "619d5e940b85926c6b23be8ec71d9c8d53b95cededfcf63432cd10e57a96ee73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "033dfd6962ac6e9409389a1874c67bbb29cc387e26f8578a5401957e8b6a5107"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a70b48b0f73ff2f60f04607e96c3b89306b5e1b935d5cd9219cf514293ff67c"
    sha256 cellar: :any_skip_relocation, ventura:       "8792ed30f3ec5599a7f6d7f9387b99f8a12b5d46fab91443579600b4a5b59bc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5467a7878c660291f57d193a848512a93b6b84fb9cbb4de0512e28842ef1e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05dfd07ca20eefcddd209c5c1c2490bee33e5928a673adbf9fb5ad0c35441f0c"
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