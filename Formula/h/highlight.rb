class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.9.tar.bz2"
  sha256 "9dd1d2d5b0b6638673270d21f6fa0dc066a6aa2dc2f4f21bcddf015a7d85a725"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "459a410a512b473800d426701e796b89e99532388a925818d3965b652864c4c2"
    sha256 arm64_ventura:  "c49048998e389d8e977088466cb23e9b582d5af127b748e31c385fef470b4c51"
    sha256 arm64_monterey: "2e2a8d773b0fd9f87c41f259361924d0f6c561ffa39bd96d87176a291cd9934c"
    sha256 sonoma:         "9f8bcfbe2ae13b3e77b73cdeef0d646d35e386fc61b643a5f9ecfd9b0492dc26"
    sha256 ventura:        "95225fd4a1dc20c81f1e8a30460b1a69f6ab59601f2a990c84369edd2dea5905"
    sha256 monterey:       "af734e0ff533bb95bd61b8a8e2cc143c29bc23e38a4ddc41b479f53e00e8f4e7"
    sha256 x86_64_linux:   "1811936d1f9b4e3d53dcd1f14b29cb363c61e2f7619e26ba8d4921ab14a2fe4e"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  fails_with gcc: "5" # needs C++17

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end