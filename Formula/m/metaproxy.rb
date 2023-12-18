class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https:www.indexdata.comresourcessoftwaremetaproxy"
  url "https:ftp.indexdata.compubmetaproxymetaproxy-1.21.0.tar.gz"
  sha256 "874223a820b15ee2626240c378eee71e31a4e6d3498a433c94409c949e654fae"
  license "GPL-2.0-or-later"
  revision 2

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https:ftp.indexdata.compubmetaproxy"
    regex(href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5d9b4d33412b474fe213a4fb8bfe5ca593d2a1248e605f8100df76d7da202fc"
    sha256 cellar: :any,                 arm64_ventura:  "a7493932dc0c7626d7dfb352475c77b3222bf901fe69840eb6518b82e42ea23d"
    sha256 cellar: :any,                 arm64_monterey: "da71b3ce74fd2efaf026c78d15eb88ac2c1c0e09f56fb29b38b8c161ec04db41"
    sha256 cellar: :any,                 sonoma:         "e943ea0630efe57688244642acd0172c49e6a7f71a4a13654eb0713c3d44dcc7"
    sha256 cellar: :any,                 ventura:        "be047393c79d9a9d4a1976f873f156a622a3f16eb91048b4c701aa7beaa4e949"
    sha256 cellar: :any,                 monterey:       "a00fd54b9fbb8579aa615047acd4ff892981b248d1ac7c8b1b34810b8e1e97b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1118fcfa98ffcbaa2d43cbd775c496e7808981b0238cafcd572712f09d001f71"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yazpp"

  fails_with gcc: "5"

  def install
    # Match C++ standard in boost to avoid undefined symbols at runtime
    # Ref: https:github.comboostorgregexissues150
    ENV.append "CXXFLAGS", "-std=c++14"

    system ".configure", *std_configure_args
    system "make", "install"
  end

  # Test by making metaproxy test a trivial configuration file (etcconfig0.xml).
  test do
    (testpath"test-config.xml").write <<~EOS
      <?xml version="1.0"?>
      <metaproxy xmlns="http:indexdata.commetaproxy" version="1.0">
        <start route="start">
        <filters>
          <filter id="frontend" type="frontend_net">
            <port max_recv_bytes="1000000">@:9070<port>
            <message>FN<message>
            <stat-req>fn_stat<stat-req>
          <filter>
        <filters>
        <routes>
          <route id="start">
            <filter refid="frontend">
            <filter type="log"><category access="false" line="true" apdu="true" ><filter>
            <filter type="backend_test">
            <filter type="bounce">
          <route>
        <routes>
      <metaproxy>
    EOS

    system "#{bin}metaproxy", "-t", "--config", "#{testpath}test-config.xml"
  end
end