class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://ghfast.top/https://github.com/containers/podman-tui/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "a241119e1099711f889bae6fa7061130869317b711a96e3e9df2fed45e6fc979"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "210be70775f4d78334aa2798764dd2d47a59ec886406ce737d4892f4258993d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a38c44d5b83478e0f36d795843c922f21d33390d973405fe82f04302fb3de570"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6204a1ab8aa41506b560d4de20abd793d25cc642a7b77d5747cd24598ad2174"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e0f2ae0fd182edad757b4922abc4f732cc56086e3d9a079150fd34d9142bcc3"
    sha256 cellar: :any_skip_relocation, ventura:       "38f29eabae4be7105afb7c7abdaa63b94373e0458e5e785562876fc686cc6670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab17a059a2c9818545a7167234bfe652194ba456be8b5213c8344cfe63959eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d09c93ca1436cb15afb4eb687ae2fe99c25b5db821bf21ba697a44bdf015c1f"
  end

  depends_on "go" => :build

  def install
    if OS.mac?
      system "make", "binary-darwin"
      bin.install "bin/darwin/podman-tui" => "podman-tui"
    else
      system "make", "binary"
      bin.install "bin/podman-tui" => "podman-tui"
    end
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"podman-tui") do |r, w, _pid|
      sleep 4
      w.write "\cC"
      begin
        output = r.read
        assert_match "Connection:", output
        assert_match "SYSTEM CONNECTIONS[1]", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match "podman-tui v#{version}", shell_output("#{bin}/podman-tui version")
  end
end