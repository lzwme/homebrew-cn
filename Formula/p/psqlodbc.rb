class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https:odbc.postgresql.org"
  url "https:github.compostgresql-interfacespsqlodbcarchiverefstagsREL-17_00_0003.tar.gz"
  sha256 "cb45cc17314f452c410be0638870b58b176f1a5b8124d66edf5137baaaa9fbf3"
  license "LGPL-2.0-or-later"
  head "https:github.compostgresql-interfacespsqlodbc.git", branch: "main"

  livecheck do
    url :stable
    regex(^REL[._-]?v?(\d+(?:[._]\d+)+)$i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e83bb9f612447f1cbb367d2f2126fdbc74d0d7badbf62336c89b85cd658e9a9b"
    sha256 cellar: :any,                 arm64_sonoma:  "b2a37444d6aa03118abab138681f3c15d2bebdbfe83f3a44d715892651ed1763"
    sha256 cellar: :any,                 arm64_ventura: "61b1b78c23710b2b1105aac67bc09cbe3a3340f14c076bcd87c645e440d32388"
    sha256 cellar: :any,                 sonoma:        "b4a6964263effa44b4723df323e0ecbb3e3fc9f3f4cd9eb0c619f2e468929512"
    sha256 cellar: :any,                 ventura:       "122abe958ffaa7c861d7cf2048c40c84973732b73b7f0d63753bab66902557ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9891fc4ee0c9124c289e2630e9e552cd700afebe67f4c5d963beff831d5e4d83"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpq"
  depends_on "unixodbc"

  def install
    system ".bootstrap"
    system ".configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}dltest #{lib}psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}psqlodbcw.so\n", output
  end
end