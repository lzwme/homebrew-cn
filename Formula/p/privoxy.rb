class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https:www.privoxy.org"
  url "https:downloads.sourceforge.netprojectijbswaSources3.0.34%20%28stable%29privoxy-3.0.34-stable-src.tar.gz"
  sha256 "e6ccbca1656f4e616b4657f8514e33a70f6697e9d7294356577839322a3c5d2c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "97f2f5971c167ff964445e8294e6b577ecfab9edc660133281ddc77f066ccc77"
    sha256 cellar: :any,                 arm64_sonoma:  "08aeaed4a5bceb64b7133cd1b9cedc8caa425de38581020e7b2c8554ec0609fd"
    sha256 cellar: :any,                 arm64_ventura: "064cbe795744a5e15d18b2f2fa28b92992fcb2eae53fd6de3546908b0f2f041f"
    sha256 cellar: :any,                 sonoma:        "b209390e2cdaf34c07e1530708abacb1613b08e8c8bec9a237c36200882e4f54"
    sha256 cellar: :any,                 ventura:       "97bb54f2c404b840d1d12e25a1093b767ceacdb2cb829b3ee7178ac755693deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d2377396f93e9ddfb8725a754533e1ce4e9077d15087773f6a9f807b50ae533"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre2"

  uses_from_macos "zlib"

  # Backport PCRE2 support from HEAD. Remove in the next release.
  # Same patches used by Debian (excluding regression testcase 87253c99)
  patch do
    url "https:www.privoxy.orggitweb?p=privoxy.git;a=patch;h=53748ca8ca3c893025be34dd4f104546fcbd0602"
    sha256 "61861bc3809f06eb77129d466c6e27f35972fa4aef8be2db2b6a789a3700fee8"
  end
  patch do
    url "https:www.privoxy.orggitweb?p=privoxy.git;a=patch;h=e73b93ea9ad1f3e980bd78ed3ebf65dedbb598a2"
    sha256 "19e58a263c308ada537109092e9b5dbb0e1625ce486b605d1392b72449adc174"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  service do
    run [opt_sbin"privoxy", "--no-daemon", etc"privoxyconfig"]
    keep_alive true
    working_dir var
    error_log_path var"logprivoxylogfile"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    (testpath"config").write("listen-address #{bind_address}\n")
    pid = spawn sbin"privoxy", "--no-daemon", testpath"config"
    begin
      sleep 5
      output = shell_output("curl --head --proxy #{bind_address} https:github.com")
      assert_match "HTTP1.1 200 Connection established", output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end