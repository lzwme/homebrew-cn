class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.22.1.tar.gz"
  sha256 "d67a9f7fc9d36ccea8c4770c96c4ae2bc4250f484f941cbeec2a11695ec8d7b8"
  license "GPL-2.0-or-later"
  revision 3

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f14fa4d6ea346f7e3e2b90c71d8679a598956497304f7c5ae4eb130d383d2205"
    sha256 cellar: :any,                 arm64_sequoia: "ca8dbb7a8d52e82d5df2d6c64fdaf9ed908db26d8eb4259c023fb28958e90754"
    sha256 cellar: :any,                 arm64_sonoma:  "2c7303f53ffdaa10fcb15af1a95eee8e99df4a517d2a3d861ac27d4481452a79"
    sha256 cellar: :any,                 sonoma:        "5d84218f0e6984fa70ed4166d863043623083ca97a9b11bca3e64764587431e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ef38bcc069a2e3dbd538259e582a3f45d17cee08cecd8a0997d4ff4f665c633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d07a86c33e951d08458bf41cdbba595b8e8f210d23e1132507114dcdbaea4e39"
  end

  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "yaz"
  depends_on "yazpp"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    # Match C++ standard in boost to avoid undefined symbols at runtime
    # Ref: https://github.com/boostorg/regex/issues/150
    ENV.append "CXXFLAGS", "-std=c++14"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  # Test by making metaproxy test a trivial configuration file (etc/config0.xml).
  test do
    (testpath/"test-config.xml").write <<~XML
      <?xml version="1.0"?>
      <metaproxy xmlns="http://indexdata.com/metaproxy" version="1.0">
        <start route="start"/>
        <filters>
          <filter id="frontend" type="frontend_net">
            <port max_recv_bytes="1000000">@:9070</port>
            <message>FN</message>
            <stat-req>/fn_stat</stat-req>
          </filter>
        </filters>
        <routes>
          <route id="start">
            <filter refid="frontend"/>
            <filter type="log"><category access="false" line="true" apdu="true" /></filter>
            <filter type="backend_test"/>
            <filter type="bounce"/>
          </route>
        </routes>
      </metaproxy>
    XML

    system bin/"metaproxy", "-t", "--config", testpath/"test-config.xml"
  end
end