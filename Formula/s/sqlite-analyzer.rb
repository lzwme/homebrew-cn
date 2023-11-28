class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3440200.zip"
  version "3.44.2"
  sha256 "73187473feb74509357e8fa6cb9fd67153b2d010d00aeb2fddb6ceeb18abaf27"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7f8e4105adbf039d6edc7e5c7650cab960b1806ee2dd444aa970b408c60a9d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "043a71bcc544c88634c49ca09983cb5012eb54f3c579e61ccfb5e295775a59bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4978fb9bc1733f0cfb6fbce479a1ed4dc679d8bbc4ab8d2a8bfa09eb580e54e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac44c2049e675c2ca60a642e954fed6d90ad63e23d085600a21e892ca2b39625"
    sha256 cellar: :any_skip_relocation, ventura:        "3ea8548feab83d6448dae2b818a664680f61f9d965207d7acc25a1ea0ccafa0c"
    sha256 cellar: :any_skip_relocation, monterey:       "62889f9e733e90387d566e74385b14151fd43dbc9cf6f580870f479c566edd68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dd84234efcfdcb5da0674dff034d848f4274515f2df2a242144f4e86206d5f2"
  end

  uses_from_macos "sqlite" => :test
  uses_from_macos "tcl-tk"

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      Formula["tcl-tk"].opt_lib
    end

    system "./configure", "--disable-debug",
                          "--with-tcl=#{tcl}",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end