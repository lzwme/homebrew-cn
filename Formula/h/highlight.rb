class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "https://gitlab.com/saalen/highlight/-/archive/v4.19/highlight-v4.19.tar.gz"
  sha256 "0f243a9fb72da88148db473c9411c92c4988bf940bff32eef939bc1efa0017c8"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e75d5c1ddfc038f7de37299e4438ecee09cf7e4605fbb56476e2dc9534495a05"
    sha256 arm64_sequoia: "1481a98880db38fcf0941b1b6dceb09e9a2b22f55a2aff36e4dd052472ea54b6"
    sha256 arm64_sonoma:  "4c9d1d55742adfb4bd11f6819b274ec61aa62d255471c316a1abea9938a4f5dc"
    sha256 sonoma:        "3e10d7a454c39701ea70ecdffe29847a8f3d567e03861c16f5e979b450a161f9"
    sha256 arm64_linux:   "188f28db47d9b11f15fd3ce4065d5ab7df0c906c64e0d8bc396a24da5ca4d45c"
    sha256 x86_64_linux:  "5dfd49a9add8995bd7fe319f8b06dd4a0674775268c5032c66fa7953cbe67763"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end