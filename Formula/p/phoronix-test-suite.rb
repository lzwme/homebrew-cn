class PhoronixTestSuite < Formula
  desc "Open-source automated testingbenchmarking software"
  homepage "https:www.phoronix-test-suite.com"
  url "https:github.comphoronix-test-suitephoronix-test-suitearchiverefstagsv10.8.4.tar.gz"
  sha256 "7b5da7193c0190c648fc0c7ad6cdfbde5d935e88c7bfa5e99cd3a720cd5e2c5a"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comphoronix-test-suitephoronix-test-suite.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71a7a32f236bc22d0990168e1fceb1d8811748295c064741177f9bdba6f905fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a7a32f236bc22d0990168e1fceb1d8811748295c064741177f9bdba6f905fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71a7a32f236bc22d0990168e1fceb1d8811748295c064741177f9bdba6f905fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "130079ac169569c6e2c45a6a31d25ce285606cbfc4ed03ccd7b2e2488d8a162d"
    sha256 cellar: :any_skip_relocation, ventura:       "130079ac169569c6e2c45a6a31d25ce285606cbfc4ed03ccd7b2e2488d8a162d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a7a32f236bc22d0990168e1fceb1d8811748295c064741177f9bdba6f905fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71a7a32f236bc22d0990168e1fceb1d8811748295c064741177f9bdba6f905fb"
  end

  depends_on "php"

  def install
    # Use homebrew's share directory
    inreplace "phoronix-test-suite", "usrsharephoronix-test-suite", "#{pkgshare}"

    ENV["DESTDIR"] = buildpath"dest"
    system ".install-sh", prefix
    prefix.install (buildpath"dest#{prefix}").children
    bash_completion.install "dest#{prefix}..etcbash_completion.dphoronix-test-suite"
  end

  test do
    cd pkgshare if OS.mac?

    # Work around issue directly running command on Linux CI by using spawn.
    # Error is "Forked child process failed: pid ##### SIGKILL"
    require "pty"
    output = ""
    PTY.spawn(bin"phoronix-test-suite", "version") do |r, _w, pid|
      sleep 10
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end

    assert_match version.to_s, output
  end
end