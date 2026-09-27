class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2026_09_25.df90211.tar.xz"
  version "2026_09_25.df90211"
  sha256 "cdf655b5677ce219108cf3df93a55e0ae98a376887be110fe35303ea900d5d68"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "4cc813bd2402449099158629203797b12bb63cff31d8a25ff7095f9791b5dbdc"
    sha256 cellar: :any, x86_64_linux: "0081fa5d3e3aa4d19fa87f0de79f4ddd25811a6a16f01c441ede58085cbd90fc"
  end

  depends_on :linux

  def install
    args = ["prefix=#{prefix}"]
    args << "VERSION=#{version}" if build.stable?
    system "make", "install", *args
  end

  test do
    require "pty"
    PTY.spawn("#{bin}/passt --version") do |r, _w, _pid|
      sleep 1
      assert_match "passt #{version}", r.read_nonblock(1024)
    end

    pidfile = testpath/"pasta.pid"
    begin
      # Just check failure as unable to use pasta or passt on unprivileged Docker
      output = shell_output("#{bin}/pasta --pid #{pidfile} 2>&1", 1)
      assert_match "Unable to create user namespace", output
    ensure
      if pidfile.exist? && (pid = pidfile.read.to_i).positive?
        Process.kill("TERM", pid)
      end
    end
  end
end