class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ghfast.top/https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-17_00_0009.tar.gz"
  sha256 "058fbde82c45b3b2f37245f26cf5b8c6ebe1fea94ff1a0ce86d4a99bb3c5a0ac"
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
    sha256 cellar: :any,                 arm64_tahoe:   "12378b478ce612aa599187d34483ff6de7fc1c9fadbbf07173d28d736d5aa15d"
    sha256 cellar: :any,                 arm64_sequoia: "4f32f1c43e9499a9f736c8011225e3a1ed53217e80e56787540702ac786c3bdb"
    sha256 cellar: :any,                 arm64_sonoma:  "29147dcc50ef34e95f32d247e692a4b31f6eeb719f97a7a5cbcf4438768eede4"
    sha256 cellar: :any,                 sonoma:        "2de48cf3ad3b68d7f333c382dca9489d966f9963fb1c2511a29910abc9c19363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5d5e7cfdc9ab6d21424ec961ba45330beec0ebb84901df4b10c5201afb865d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fdd08529084507d1636c180a12f2034044f8c26b642d43558beaf64c00c87f8"
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