class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://ghfast.top/https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.5.0/clamav-1.5.0.tar.gz"
  mirror "https://www.clamav.net/downloads/production/clamav-1.5.0.tar.gz"
  sha256 "09026c8b912b6c2a593d325318e99df7d763c9df013fff0d48ef3b2215fb53ee"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "a5dc2b40636452f440767de1c22fd83a54ba33e8a4cf8026a8a1a2315c27e0c3"
    sha256 arm64_sequoia: "ca453f0dcad5960d757268fa548a515ca785f774cd9085316e22f89855a06686"
    sha256 arm64_sonoma:  "1834c53423def47efc360797b8a887ce86d01a033ba7307a5196dc72b91f0b6e"
    sha256 sonoma:        "5eceed9bbf654d8a4e6b98de3d78f0fa0845f49d23236187a122df684aee6614"
    sha256 arm64_linux:   "4f3720d476e42623c3b0517552eeabc79b9eecc9d2abf4cdf12c59b1a2320f45"
    sha256 x86_64_linux:  "cfbd38f5382a681d9540dd35346e8f9adee3e7adaf954e823a70a56b0471a352"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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

    system bin/"freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system bin/"clamscan", "--database=#{testpath}", testpath
  end
end