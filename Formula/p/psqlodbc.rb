class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https:odbc.postgresql.org"
  url "https:github.compostgresql-interfacespsqlodbcarchiverefstagsREL-17_00_0000.tar.gz"
  sha256 "37567b01ce69e026f128981f775a040656c92d4756bd3fdc1b1db4030c9ffe16"
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
    sha256 cellar: :any,                 arm64_sequoia: "1e2e9ec7176800f407a29a70ef322fb244fa382f75d6cd84aef7412e7a42f7f3"
    sha256 cellar: :any,                 arm64_sonoma:  "41cbbd2b460d0c369a29334c4658367a94ae8b50822713dff08b34c72eb622a9"
    sha256 cellar: :any,                 arm64_ventura: "f7062a5e22d545f77c858208b5d9a241b5e3e337125818fd7b40f2448baadb9b"
    sha256 cellar: :any,                 sonoma:        "23305fb54f6373720b9ffb6301b5b0621318459d8c4544141ec1994b8b8f217e"
    sha256 cellar: :any,                 ventura:       "a7a41c9a335416c194e00ef44aad30366ba336307bffd728eeb843100e5c30b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d925f2943a3cb0cb9aa1be3a9fa132e6ce2e4dc54cfbef9309679276752e4b4e"
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