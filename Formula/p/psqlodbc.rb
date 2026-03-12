class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ghfast.top/https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-17_00_0008.tar.gz"
  sha256 "2718aba2929f5d8ce07f921901b27fa27c424fc297db89d3e025a436595f6626"
  license "LGPL-2.0-or-later"
  head "https://github.com/postgresql-interfaces/psqlodbc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^REL[._-]?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7907a538ee2650e756d49d26ce6b1b8ad11ea309ce17333cb1252e67ecf0f73f"
    sha256 cellar: :any,                 arm64_sequoia: "b92c46f4de344b8ba92e5d18dc472e062db9f0b7160e96d232f1297f015c13f7"
    sha256 cellar: :any,                 arm64_sonoma:  "2448e912ca0a765fa3982aec2c3dc0084551a18dd450553f441f5b5a9a2a80d5"
    sha256 cellar: :any,                 sonoma:        "b67332646649c54b710177d45b13b172afef57f842aba21f590de513608caf17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a964a977706c3ac8a2b27abdd6ab638267309624253c3ce04667108401913257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d30c267174ba037e9636221ff6a12eb52236baf5d3de0e47feebbf294a988a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpq"
  depends_on "unixodbc"

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end