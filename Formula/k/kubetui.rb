class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://ghfast.top/https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "ca967dab7e360ab9ffe4ca84c4d818792dcf58f7d4d45f5e4cb6987453fe21db"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c9c56c2f71e07c4d77b96c69cc1c313d6b8a27a0306102b2862170b1f0de494"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d023b44f861a3412d556b293bbcc96cb0646ea4e9cc72672792c13a8b019322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6acb9be20ffcc3dd4742085e4d6cc7beb670cbad64ccf9d50f67c9665be6f104"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e85997e379048b9db1aa21c48e43b43dc618287c392ff860353070e7cdbc2db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adcc768e38fbd52ec8c8f35800b68d129291f14c4d3d53eb12f017b20c7930c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba6f152474a6714806cc348d1bc525ebdbeb8f05a478a95a6952d3768a3484b1"
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