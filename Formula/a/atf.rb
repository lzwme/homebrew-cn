class Atf < Formula
  desc "Automated testing framework"
  homepage "https://github.com/freebsd/atf"
  url "https://ghfast.top/https://github.com/freebsd/atf/releases/download/atf-0.24/atf-0.24.tar.gz"
  sha256 "c21595ffbb91aef0716904ff58cdb5c28b9646c8270fd7d3ca2e2859235bf85e"
  license "BSD-2-Clause"
  head "https://github.com/freebsd/atf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "5f2a094f20f1d31cde35be2d850bc00f44c244b76beab038bd79e39c4765a554"
    sha256 arm64_sequoia: "e1c9207cabac7db02ef256c7eae72832fb65591fd351cab0d599576a4c4be580"
    sha256 arm64_sonoma:  "e0ae5d6be55233703440aa894f2805c2487bfad701b190cdc096be56c3c2406c"
    sha256 arm64_linux:   "d4860b2e9ef82af3b5c2658d7059ab7890c6191716da063db9af37b55e85598d"
    sha256 x86_64_linux:  "320ce6c56753f7271950a47722debe21555712152360ebc9a67625f7c610f468"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "glibtoolize", "--force", "--install"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      #!/usr/bin/env atf-sh
      echo test
      exit 0
    SHELL
    system "bash", "test.sh"
  end
end