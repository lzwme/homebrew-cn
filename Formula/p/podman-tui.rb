class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https:github.comcontainerspodman-tui"
  url "https:github.comcontainerspodman-tuiarchiverefstagsv1.2.1.tar.gz"
  sha256 "e97fb24ded58d5dccb71fd21221cc2cae25853797ca44e1710baeaf3d5d77b6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22b51f4ad020fcd26e2d9113f68d71f808a6c38adeef43e5d31183ec259e048c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b080011ec15e72a680852c2f00e85fbf5af6964ec2eab9e5a7dc04688a83a2d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc6f26e4ad78af5ab56b0c06a1579178984ca25cdb83789cd40ecfde4944af81"
    sha256 cellar: :any_skip_relocation, sonoma:         "a451e2ff380fda64303c71ea2bbaac185cfc8153274fdb0919be05a4ea5f61e7"
    sha256 cellar: :any_skip_relocation, ventura:        "8ab896ac2f1fc91de1238d5133e31ae659ff503f7b38da5bfd1d51707d5e9648"
    sha256 cellar: :any_skip_relocation, monterey:       "f44bf41d04c48f83b569d944316996fe142b6d8cc7ade31d0814b19e5b219210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa2123af363e4c473022471b36547c9bd6da8d82dd39201a50d5635c4439ebd7"
  end

  depends_on "go" => :build

  def install
    if OS.mac?
      system "make", "binary-darwin"
      bin.install "bindarwinpodman-tui" => "podman-tui"
    else
      system "make", "binary"
      bin.install "binpodman-tui" => "podman-tui"
    end
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin"podman-tui") do |r, w, _pid|
      sleep 4
      w.write "\cC"
      begin
        output = r.read
        assert_match "Connection:", output
        assert_match "SYSTEM CONNECTIONS[1]", output
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end

    assert_match "podman-tui v#{version}", shell_output("#{bin}podman-tui version")
  end
end