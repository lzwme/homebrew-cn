class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500300.zip"
  version "3.50.3"
  sha256 "119862654b36e252ac5f8add2b3d41ba03f4f387b48eb024956c36ea91012d3f"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99d322cffbf911bfd5e5514f31189b986c643f42ec5dff3f18b01e53c64a400b"
    sha256 cellar: :any,                 arm64_sonoma:  "28e4125b7525b7ae707eeca2fda34a926abc5f675d4c3297f627ae6ff80a8a86"
    sha256 cellar: :any,                 arm64_ventura: "13414a2614d5ad877407466e4dc276cc7f6250711deffac64ac6fec7f722dc80"
    sha256 cellar: :any,                 sequoia:       "dc25fbf76f4f67479ee01b6b8c2f94fbb68b90a1ffb025187f50ee90c4310e2c"
    sha256 cellar: :any,                 sonoma:        "818bd94442cae9d14898b8b21d725dd52f2f9c934413b8075d23f4bb596e87dc"
    sha256 cellar: :any,                 ventura:       "4ba13917fed3c9d2b8d3f65b58f876160d425ee46b7abe395894f9116cea325a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1a18fb381152a42c7d8bde6c69acafd1973cc43d72c0cc21d285d10e35fe2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4783e60230ad60bc5d97136b13de00da66361433817a32f384a1a23cf4ab765b"
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