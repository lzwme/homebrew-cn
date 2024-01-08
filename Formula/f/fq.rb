class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https:github.comcirconus-labsfq"
  url "https:github.comcirconus-labsfqarchiverefstagsv0.13.10.tar.gz"
  sha256 "fe304987145ec7ce0103a3d06a75ead38ad68044c0f609ad0bcc20c06cbfd62e"
  license "MIT"
  head "https:github.comcirconus-labsfq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "22ad970d2336565f56ae979163a54e3de07a82165f3b4f15050abf7ca3926617"
    sha256 arm64_ventura:  "909e9e74ea0d6a28cbd112383a29957597aaad6b32fd02efe61334c0db59122b"
    sha256 arm64_monterey: "ce96b506bfe342397d39c409890f63a6a424562b463fa738c802d3603bba35ee"
    sha256 sonoma:         "eb9b15284089358379211dacdf2ce810d92c27f9a344a3acff7768dc15ef7110"
    sha256 ventura:        "f0e6202567699912b509c9ec544c9b193eb86001879e8fe3d4f449e02f3f5a4b"
    sha256 monterey:       "60be8da7fc7c0e9909d92c225815e220c697e498f1b62b4206d1bf2a72b58be1"
    sha256 big_sur:        "0953c716b652e678dd83c6aadc9b42b5d2699c1d9ed234e4387a3bbaad4f09ad"
    sha256 x86_64_linux:   "e451023b35a528f0839e7e432ee2825ce4cc8deac929641da92242cd2e723128"
  end

  depends_on "concurrencykit"
  depends_on "jlog"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "bind" => :test # for `dig`
    depends_on "openssl@3"
    depends_on "util-linux"
  end

  def install
    ENV.append_to_cflags "-DNO_BCD=1"
    inreplace "Makefile", "-lbcd", ""
    inreplace "Makefile", "usrlibdtrace", "#{lib}dtrace"
    system "make", "PREFIX=#{prefix}"
    args = ["PREFIX=#{prefix}"]
    args << "ENABLE_DTRACE=0" unless OS.mac?
    system "make", "install", *args
    bin.install "fqc", "fq_sndr", "fq_rcvr"
  end

  test do
    ipv4 = shell_output("dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d '\"'").strip
    port = free_port
    pid = fork { exec sbin"fqd", "-p", port.to_s, "-n", ipv4, "-D", "-c", testpath"test.sqlite" }
    sleep 10
    begin
      assert_match "Circonus Fq Operational Dashboard", shell_output("curl 127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end