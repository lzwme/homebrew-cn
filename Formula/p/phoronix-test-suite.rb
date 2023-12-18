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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f226a00eafa09ce60f86a4dcd5d668dd6a098ea1ec65938aec5700492831618"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00a63636538deab383e64d5be455628abb1b6e43a2ed540e5446c5803cf36b3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a63636538deab383e64d5be455628abb1b6e43a2ed540e5446c5803cf36b3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00a63636538deab383e64d5be455628abb1b6e43a2ed540e5446c5803cf36b3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "aafb0a7cfbdc817c9d9c8db28c90fdeaa574d7844d43c660f9f4c5982d130b48"
    sha256 cellar: :any_skip_relocation, ventura:        "53cf0bc9ab6cc8244c0968a467b33aa86310c2677ed9829b9788d7eb971ac090"
    sha256 cellar: :any_skip_relocation, monterey:       "53cf0bc9ab6cc8244c0968a467b33aa86310c2677ed9829b9788d7eb971ac090"
    sha256 cellar: :any_skip_relocation, big_sur:        "53cf0bc9ab6cc8244c0968a467b33aa86310c2677ed9829b9788d7eb971ac090"
    sha256 cellar: :any_skip_relocation, catalina:       "53cf0bc9ab6cc8244c0968a467b33aa86310c2677ed9829b9788d7eb971ac090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00a63636538deab383e64d5be455628abb1b6e43a2ed540e5446c5803cf36b3d"
  end

  depends_on "php"

  def install
    ENV["DESTDIR"] = buildpath"dest"
    system ".install-sh", prefix
    prefix.install (buildpath"dest#{prefix}").children
    bash_completion.install "dest#{prefix}..etcbash_completion.dphoronix-test-suite"
  end

  # 7.4.0 installed files in the formula's rack so clean up the mess.
  def post_install
    rm_rf [prefix"..etc", prefix"..usr"]
  end

  test do
    cd pkgshare if OS.mac?

    # Work around issue directly running command on Linux CI by using spawn.
    # Error is "Forked child process failed: pid ##### SIGKILL"
    require "pty"
    output = ""
    PTY.spawn(bin"phoronix-test-suite", "version") do |r, _w, pid|
      sleep 2
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