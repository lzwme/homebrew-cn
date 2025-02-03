class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https:github.comsysstatsysstat"
  url "https:github.comsysstatsysstatarchiverefstagsv12.7.7.tar.gz"
  sha256 "9d8af674c99de2ecb3b3418886795fd65159aabc5da2e82d5dfa938560e3006d"
  license "GPL-2.0-or-later"
  head "https:github.comsysstatsysstat.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "9a16492c63de99d15d0122c052d8e659b5df18dcc35c07d5d6ddc10cb88bd42a"
  end

  depends_on :linux

  def install
    system ".configure",
           "--disable-file-attr", # Fix install: cannot change ownership
           "--prefix=#{prefix}",
           "conf_dir=#{etc}sysconfig",
           "sa_dir=#{var}logsa"
    system "make", "install"
  end

  test do
    assert_match("PID", shell_output("#{bin}pidstat"))
    assert_match("avg-cpu", shell_output("#{bin}iostat"))
  end
end