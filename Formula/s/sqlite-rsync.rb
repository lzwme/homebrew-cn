class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3500100.zip"
  version "3.50.1"
  sha256 "9090597773c60a49caebb3c1ac57db626fac4d97cb51890815a8b529a4d9c3dc"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_sequoia: "36a923d7889f38166fb2b250b1693a7d3c6f5a030dea68bd080e915d55639bac"
    sha256                               arm64_sonoma:  "b99b5af9b65feeaf2f4dec7ee96dbdbf9a2ad1fa6693fa90272b4b90435dc863"
    sha256                               arm64_ventura: "c1397c18bfa41c56a36cbf8c33d5d2b4a8d87b920b39f57bec8a76b165dd87f0"
    sha256 cellar: :any,                 sonoma:        "3584542d90962671d5b6bc711ef9f23163d67b2947f3f9fad725a155347f1dab"
    sha256 cellar: :any,                 ventura:       "4a1c13e4637a8fcd6ef032c538daf1301a8c7a403e90c8606c4bb6789f6d0ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71059f0bffbb31bfefacc3388e9d068ebddef63b93742452bc758dc5335f818a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e7718677ad793f8dc3d5809cfd5498d978f3e56f33acf2e8e1cfed4a66c5bcd"
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