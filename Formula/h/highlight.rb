class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "http://andre-simon.de/zip/highlight-4.12.tar.bz2"
  sha256 "0f7d03362d74dddfb3bc8419fb8198bf8c9b4a5788dec491a00cd43acdf07f1e"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6447a18ad118ce84a461d4f40b2678cabb35814883439ed53d57a7b72bc38811"
    sha256 arm64_ventura:  "9ce5ba6587f2db4629adb1e96442bc49fddd27f7104a16112257d6dc9849a70d"
    sha256 arm64_monterey: "ac12588f84ae33727f0cee526127ff72afe6b2d7ace7bcb9aa954344c752139d"
    sha256 sonoma:         "817f831449f27d254005110ea2cf5bc5595c90ef36a10a51102eeac493a183d1"
    sha256 ventura:        "7834d6069762de3f5f618f3eed92c01ead91eb6e054e3fbbd982998618d6e90d"
    sha256 monterey:       "6ec4c774794df21c153dcb2a07ad822cd1036706c63074bb36bd660f0ecb2a07"
    sha256 x86_64_linux:   "8cce2f43a7ca8bb8dbb74a5ab35d985cfb2f2cd2e136c9682092d1f1405f46f8"
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