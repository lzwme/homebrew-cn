class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://ghfast.top/https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "d6ddf724a51766d6b83f8635c9fcaa233670c3748ca80bd84a733e20167f9cd9"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6ae8cd58cc7377985b3181092d63dc406486f9846a044ed8bb0dcc0bca9e6eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "172b942a2cfd463e16a87ee2ec8d01d3c3833d906e3c7110f4b76b18cc9799e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ce0e7b3419bfce4aa9c2755468fc74f583b555335cd85e6ed2c570579976d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "beb70b1484cd2f29c11f6193ddf3c0f9f6c6078584fdd18f24770ceb99c1dd7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08ee40ff45a2ea37d9703ff514ff88da0cc870a2f0be39c90dade533df71af2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2197ff9e8e7e87b4a487cbf469edf98814f6405f617ba00197ad842e4860c09f"
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