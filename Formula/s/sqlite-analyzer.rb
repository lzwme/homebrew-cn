class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3500300.zip"
  version "3.50.3"
  sha256 "119862654b36e252ac5f8add2b3d41ba03f4f387b48eb024956c36ea91012d3f"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ade8f24275e115ed7064de91acd1d0898c55fcf0427b669eaa30874093c6b620"
    sha256 cellar: :any,                 arm64_sonoma:  "18e0cb91be041fa3e90d602a8ee50667d7940bbb06aa93e83613c044e99acf2b"
    sha256 cellar: :any,                 arm64_ventura: "059c958395fa1b46480931107d371b4bca11f560b3802ec613e63e5db61b5aad"
    sha256 cellar: :any,                 sequoia:       "0fe5ae5fb8ebce3c34fa3ec27c3d3be2cb9e9998c3155c4678aacb6854ecdee4"
    sha256 cellar: :any,                 sonoma:        "1ad99fbd73f8e309138134c3d95283a0d898dc7a0978efd1e75b1bcd0fb2d217"
    sha256 cellar: :any,                 ventura:       "4519eb1cb3a3266a6e3725bedb5dbefaf6cb3c5688a33379353b27dd70470eb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc0a1bb43c7283ce4c4eb5bc0335792094f6f712be9203fd75a70b34867d8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6297a639ed4f5fd94416b28c6e2a6020708149719e3ddc547442e1e159f73bd2"
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