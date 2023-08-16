class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://ghproxy.com/https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.1.0/clamav-1.1.0.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.1.0.tar.gz"
  sha256 "a30020d99cd467fa5ea0efbd6f4f182efebf62a9fc62fc4a3a7b2cc3f55e6b74"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "662ffabfc4ae40f797d06e4dec92b28c6829c098f77e6fa97db671a11899d97a"
    sha256 arm64_monterey: "1ce783e4d2e2ba813481313e85567be5028cb4f92967413c5a947dd18e5725b4"
    sha256 arm64_big_sur:  "d15441ba011b2b7e7396eea172b967c3dfc3a6d7e84faa619c315291a6a85e97"
    sha256 ventura:        "e5e2328cc4283169013fe320e170f357388526f2ca9c6802e74accaf0e507967"
    sha256 monterey:       "ff7217fd2414ee715481ae64c4f189d07ead1f293290a8f7a2ad48efc7e1b5bd"
    sha256 big_sur:        "9eeed4584fd2cf1b855f026863d329875ad1013a203f51a63107b9972d36d0cc"
    sha256 x86_64_linux:   "cbc83747e96b646908950b2988fedcc7536f085fd4602e448d30c71d3baeee84"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "yara"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  skip_clean "share/clamav"

  def install
    args = %W[
      -DAPP_CONFIG_DIRECTORY=#{etc}/clamav
      -DDATABASE_DIRECTORY=#{var}/lib/clamav
      -DENABLE_JSON_SHARED=ON
      -DENABLE_STATIC_LIB=ON
      -DENABLE_SHARED_LIB=ON
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_MILTER=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"lib/clamav").mkpath
  end

  service do
    run [opt_sbin/"clamd", "--foreground"]
    keep_alive true
    require_root true
  end

  def caveats
    <<~EOS
      To finish installation & run clamav you will need to edit
      the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    assert_match "Database directory: #{var}/lib/clamav", shell_output("#{bin}/clamconf")
    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS
    system "#{bin}/freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system "#{bin}/clamscan", "--database=#{testpath}", testpath
  end
end