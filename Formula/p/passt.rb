class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2025_12_08.e8b56a3.tar.xz"
  version "2025_12_08.e8b56a3"
  sha256 "98ae8c318c11e861ab6f62e38aaeefe789d65a6e2382b0c9e751a3831afbf14b"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "4b98227b396a1f49145a1b848b7018e81355e335b1534c641c10fa0144a5ba80"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "04c8a400400e3452af338e05af59b91ed124756c32b8a718e4e6a93c8aab8dac"
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
      assert_match "Couldn't create user namespace: Operation not permitted", output
    ensure
      if pidfile.exist? && (pid = pidfile.read.to_i).positive?
        Process.kill("TERM", pid)
      end
    end
  end
end