class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://maxmind.github.io/libmaxminddb/"
  url "https://ghfast.top/https://github.com/maxmind/libmaxminddb/releases/download/1.14.0/libmaxminddb-1.14.0.tar.gz"
  sha256 "65ff92382c71ef6634b8c13e278651a2efa68f1de28ef3c31fc32369fa0bb3e3"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "356cb6ae3a3752cb122c3a4e40f9a626d27653a215b306c233d759b0ad5f7179"
    sha256 cellar: :any, arm64_tahoe:       "e4107282fb32a5ab8f0afd041b728b1a1f745d4eeec839df4ae13705292c5ca2"
    sha256 cellar: :any, arm64_sequoia:     "35c41f989a8b2c002518651170d92cedcc25750fabece9a629eb4b0d2f486b99"
    sha256 cellar: :any, arm64_sonoma:      "3718ffa35dc8af95c5b40b49f8cb147c4f323cd7dd7505a4d30b5c7ebcee957b"
    sha256 cellar: :any, arm64_linux:       "2f3a969e51ce95674b1b445b190d75e05b08f125f18ea020146d025ee4c3d29f"
    sha256 cellar: :any, x86_64_linux:      "c72a6fcee7b1132d4c17b0f530ed0613c302b3981796baf0829841a7366b64c6"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  deny_network_access!

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system bin/"mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end