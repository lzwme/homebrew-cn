class Clamav < Formula
  desc "Anti-virus software"
  homepage "https:www.clamav.net"
  url "https:github.comCisco-Talosclamavreleasesdownloadclamav-1.2.1clamav-1.2.1.tar.gz"
  mirror "https:www.clamav.netdownloadsproductionclamav-1.2.1.tar.gz"
  sha256 "9a14fe870cbb8f5f79f668b789dca0f25cc6be22abe32f4f7d3677e4ee3935b0"
  license "GPL-2.0-or-later"
  head "https:github.comCisco-Talosclamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "733a315cf867ef7fe2447eb2c52b8ab0394872e0de1daab072ebc32f3a3bd3af"
    sha256 arm64_ventura:  "a2851d8fb5c97dd1709d2c0e743a8ea7c971625459f2ab0f6d7ba3c95976dc12"
    sha256 arm64_monterey: "8cd7b582471f44ee3c567aaba308c6ba759b072d59c1d559dbb26cf8622e5007"
    sha256 sonoma:         "8d1562e43666c2d324ba3661cfa3cdce1bee0ffbb70b3863f48c7db2a03ba765"
    sha256 ventura:        "7596c6df69321e87696100b367439b8251857e8c4aaa6699b04b3fbe0f6b1d80"
    sha256 monterey:       "6cb2b97f77ae97cf801772facd7ed1cbef1e9230fd1f0223f6fa2510484947c0"
    sha256 x86_64_linux:   "9dadd78ac5c5f0b96894a186e3a461e5571466d78467271aa9a961de3d87f9a8"
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

  skip_clean "shareclamav"

  def install
    args = %W[
      -DAPP_CONFIG_DIRECTORY=#{etc}clamav
      -DDATABASE_DIRECTORY=#{var}libclamav
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
    (var"libclamav").mkpath
  end

  service do
    run [opt_sbin"clamd", "--foreground"]
    keep_alive true
    require_root true
  end

  def caveats
    <<~EOS
      To finish installation & run clamav you will need to edit
      the example conf files at #{etc}clamav
    EOS
  end

  test do
    assert_match "Database directory: #{var}libclamav", shell_output("#{bin}clamconf")
    (testpath"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS
    system "#{bin}freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}freshclam.conf"
    system "#{bin}clamscan", "--database=#{testpath}", testpath
  end
end