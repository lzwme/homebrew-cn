class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.23.4.tar.gz"
  sha256 "b627af58880cd92532eea396ecc26c69f502452c8d37aacf93309bcdb370acb7"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "b875ee67577ab96da3d7c593218e407fd8249c46aebf215bac34c2ed2318aa08"
    sha256 arm64_sonoma:  "189211ad4ba779d31573fd9a1332760e85588ac8e5e52453d89688fb716d4931"
    sha256 arm64_ventura: "5252fe02085962df9e3fb10042f5e801a58b71dc4f5d53bef69c585407349a2a"
    sha256 sonoma:        "0cee6423aa6b66ece3d65aa17a1d3d9f6d22c2411d6f6f4d90fea0cf9ed6ef23"
    sha256 ventura:       "911268aac598d09cc6815cc086345c8356b6ad1c5933ef3e4ea03b0de9da0c53"
    sha256 arm64_linux:   "4c483da4df5cc0bee310dad7edf51fcbc40101963642e0a639ea021bdcb51437"
    sha256 x86_64_linux:  "9423c04a5e4863ad4f29d613581d0a9b769f75d8dee19f9e83db6f15d1d0b2f1"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  def install
    args = %W[
      --mandir=#{man}
      --enable-ipv6
      --enable-data-rootdir=#{var}/silk
    ]
    # Work around macOS Sonoma having /usr/bin/podselect but Pod::Select was
    # removed from Perl 5.34 resulting in `Can't locate Pod/Select.pm in @INC`
    args << "ac_cv_prog_PODSELECT=" if OS.mac? && MacOS.version == :sonoma

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    (var/"silk").mkpath
  end

  test do
    input = test_fixtures("test.pcap")
    yaf_output = shell_output("yaf --in #{input}")
    rwipfix2silk_output = pipe_output("#{bin}/rwipfix2silk", yaf_output)
    output = pipe_output("#{bin}/rwcount --no-titles --no-column", rwipfix2silk_output)
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end