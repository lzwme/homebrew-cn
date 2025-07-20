class SqliteRsync < Formula
  desc "SQLite remote copy tool"
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
    sha256                               arm64_sequoia: "f1b591d5fa5e46dc0385ec280d536cc717406036487d448e22f41861b07075de"
    sha256                               arm64_sonoma:  "39a4bd06d012d7be2d516aeebde92abfb54996b3e7b851e730f29966a3796f9c"
    sha256                               arm64_ventura: "10737a77bd660689837fc448fa3a2bb700ffce5392e032a5a8e7582fa75def32"
    sha256 cellar: :any,                 sequoia:       "63ff290317a2856d8bd5bae13d3528e72eb68283eaf1f5ac5449f1b0ec7be03d"
    sha256 cellar: :any,                 sonoma:        "434356e8b01a1ba478e73f60b01f492d214d45e540306df69abc88d30835632a"
    sha256 cellar: :any,                 ventura:       "d64606c3b8df302e10f72006dc30a1992093fb2e4c5140002ba69397f440da11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56886461e188ada1992cf560a95a0e1dbbfacfab7ade86dad68766c89ea59d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c33fd52d0f4c50e1332292edaff0b146cfb72ae841f4b88a0bd2852430335f4"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      Formula["tcl-tk"].opt_lib
    end

    system "./configure", "--disable-debug",
                          "--with-tcl=#{tcl}",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_rsync"
    bin.install "sqlite3_rsync"
  end

  test do
    dbpath = testpath/"school.sqlite"
    copypath = testpath/"school.copy"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    cp dbpath, copypath

    addpath = testpath/"add.sql"
    addpath.write <<~SQL
      insert into students (name, age) values ('Frank', 15);
      insert into students (name, age) values ('Clare', 11);
    SQL
    system "sqlite3 #{dbpath} < #{addpath}"
    system bin/"sqlite3_rsync", dbpath, copypath
    assert_match "Clare", pipe_output("sqlite3 #{copypath}", "select name from students where age = 11")
  end
end