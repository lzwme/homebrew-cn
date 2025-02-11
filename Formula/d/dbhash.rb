class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2025/sqlite-src-3490000.zip"
  version "3.49.0"
  sha256 "bec0262d5b165b133d6f3bdb4339c0610f4ac3d50dee53e8ad148ece54a129d0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1cb6c037276aba51e45c7289c6056f72cac1b1b677ba9a2fefc0ee05f2bb0e4"
    sha256 cellar: :any,                 arm64_sonoma:  "d94d843d38aa564561a68ccfea1fbd6e0ea9c4f3af0a44a07dae7ff1cd68f709"
    sha256 cellar: :any,                 arm64_ventura: "ecde5eefe2338ce27c52bba65f165daf7f27b8dc73f465a0a180a5e4633f4809"
    sha256 cellar: :any,                 sonoma:        "63ebbd71e1a98de142b5cb9a6db4d70eebdc7a1a8e2a36bb8359f6cf57437269"
    sha256 cellar: :any,                 ventura:       "9431a32a3616dac1435ec509f8807696d97b65d58a48103388b182ff56a8118f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "101d55cb99416e2b0f9ecdd2170d30a70ab931a17d8e4e61c4abb020b0ba0e3d"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end