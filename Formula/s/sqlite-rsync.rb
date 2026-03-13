class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2026/sqlite-src-3520000.zip"
  version "3.52.0"
  sha256 "652a98ca833ed638809a52bec225a7f37799f71a995778f9ccb68ad03bd1fc11"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_tahoe:   "a511d8e412735b283d706ac97ef7d15c3ad06f4f92ab1698373bbaf485f5c454"
    sha256                               arm64_sequoia: "820d4b82a0133e99be511f88d0da614ad6b4106abcc7b83e87e9be6953d69b1f"
    sha256                               arm64_sonoma:  "d8531af3531c7d8ea663026a6a68e8f9cf102abc086944a38d3932f081a3eded"
    sha256 cellar: :any,                 tahoe:         "bc2f18e29f38c03a259817b01f9be406fd7ca441bb79321aafaddd446de14a38"
    sha256 cellar: :any,                 sequoia:       "cb583387017aefca0e043f798b6dab1d402f1faa39e51000e18e9a1f123f283f"
    sha256 cellar: :any,                 sonoma:        "f8d0d961aefccb86cc9672d711680db3f5cab79fc4ec40bf45dc9ef74b25b7f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3652fde83ffe2a650518e193961ca16f8ad99452826f522a2d634f2f20a8a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f3850881eb522af939b269efb86aa83ef03219debc120e3b6a83f29ab5c9b4e"
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