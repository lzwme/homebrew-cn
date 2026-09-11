class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ghfast.top/https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-18_00_0003.tar.gz"
  sha256 "c99b58d3ee18343bb0394c3a0d2e49d80c1a466e6e1ef999e4201a8acdb3f14d"
  license "LGPL-2.0-or-later"
  head "https://github.com/postgresql-interfaces/psqlodbc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^REL[._-]?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3bc8fdeb796c89790022b29289ecbce07c02b5d043d3a5b1e5dd1bdf20da069d"
    sha256 cellar: :any, arm64_sequoia: "7c92ca022fd047403add1bdf3b283cab6b86743664b5ee750e84ec4bff4c56e9"
    sha256 cellar: :any, arm64_sonoma:  "c64a24e63cb798ffb8f1bd4900cf8f8d1bbede7c7b596214d9d3311b5c3bbdf4"
    sha256 cellar: :any, arm64_linux:   "a19ab18b33667c9c19ae01695fffb3a7f29c459612c795e38742c68efb2d4cfe"
    sha256 cellar: :any, x86_64_linux:  "c3ab8790e4dcdc00a4f3a517cd3684c46772fe88c62eb4c9f3699936fa1a0000"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpq"
  depends_on "unixodbc"

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{formula_opt_prefix("unixodbc")}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end