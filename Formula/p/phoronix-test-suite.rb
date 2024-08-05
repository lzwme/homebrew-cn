class PhoronixTestSuite < Formula
  desc "Open-source automated testingbenchmarking software"
  homepage "https:www.phoronix-test-suite.com"
  url "https:github.comphoronix-test-suitephoronix-test-suitearchiverefstagsv10.8.4.tar.gz"
  sha256 "7b5da7193c0190c648fc0c7ad6cdfbde5d935e88c7bfa5e99cd3a720cd5e2c5a"
  license "GPL-3.0-or-later"
  head "https:github.comphoronix-test-suitephoronix-test-suite.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d864f4ef6757c34a9633f69b1096ade2927797be0493d5e9d5969cba375f512"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d864f4ef6757c34a9633f69b1096ade2927797be0493d5e9d5969cba375f512"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d864f4ef6757c34a9633f69b1096ade2927797be0493d5e9d5969cba375f512"
    sha256 cellar: :any_skip_relocation, sonoma:         "f97dee399c72ee996f9deb479a9bcdb016a4cc4329b7f96c99ebe617daa3333b"
    sha256 cellar: :any_skip_relocation, ventura:        "f97dee399c72ee996f9deb479a9bcdb016a4cc4329b7f96c99ebe617daa3333b"
    sha256 cellar: :any_skip_relocation, monterey:       "f97dee399c72ee996f9deb479a9bcdb016a4cc4329b7f96c99ebe617daa3333b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d864f4ef6757c34a9633f69b1096ade2927797be0493d5e9d5969cba375f512"
  end

  depends_on "php"

  def install
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