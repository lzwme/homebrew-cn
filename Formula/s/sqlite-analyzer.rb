class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3490000.zip"
  version "3.49.0"
  sha256 "bec0262d5b165b133d6f3bdb4339c0610f4ac3d50dee53e8ad148ece54a129d0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "989b0213cd7a3041baa091f9803cd0176a2376f1ef0cc87e8d2e6a687d2a946d"
    sha256 cellar: :any,                 arm64_sonoma:  "1438105599302df0594913531465b01da820ee787c8f19bd1aef3f4d9f40d38a"
    sha256 cellar: :any,                 arm64_ventura: "83c8e040d3ed7193e1711d2db486b6850df9b8f353dc8432ca14207f3e57d3d2"
    sha256 cellar: :any,                 sonoma:        "26c08d8afdd38f91f533214b4566449647728e293a59061d1a8b5d3bc1d2d130"
    sha256 cellar: :any,                 ventura:       "159ee9368c20288f00d71e72c56675cffb848d850a2947d464cf87631b6ff36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32d8c92bc653e1b0bda363dc70b2603839436fb5e18610e7a39e412bb85688f9"
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
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end