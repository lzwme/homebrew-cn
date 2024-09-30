class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https:odbc.postgresql.org"
  url "https:github.compostgresql-interfacespsqlodbcarchiverefstagsREL-17_00_0001.tar.gz"
  sha256 "34136e5aecd44dbffa175c6b234e67e3955f63d0f4004e7f2cbc813303ebbdc2"
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
    sha256 cellar: :any,                 arm64_sequoia: "908ca6087a4287d945a128bbdcea55d36356a8fb9fbd242a9311de08f13a7b3e"
    sha256 cellar: :any,                 arm64_sonoma:  "73a13b7a4eed784a6d759103f1bf6e5b4259ec17ac18b7f261876dccd4278c4d"
    sha256 cellar: :any,                 arm64_ventura: "8cc962567391448a8b2d66028b5f45d8f786918656fb3c7373ab7a79ae7328fc"
    sha256 cellar: :any,                 sonoma:        "1c3fe2901fee35067ce9ab50a0ce2e6574feb26271c5a1d23adbe2983a3d0113"
    sha256 cellar: :any,                 ventura:       "966d74db2ce2abc788d55d7ba5ec300b31e4845c0b84fdc15ca8578790919d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eec9ffb65aaf1198987c9e0aff7946bf9732c7e670f7de9504779308c44d1892"
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