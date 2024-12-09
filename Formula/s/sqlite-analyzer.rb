class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2024/sqlite-src-3470200.zip"
  version "3.47.2"
  sha256 "e6a471f1238225f34c2c48c5601b54024cc538044368230f59ff0672be1fc623"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c96ac935e155087c84b8232ee43fd63a046fcf41722946b766a1654ee931d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e953e3fe7d14931a6f8ed3fd30bb8248694d47dc32c5333126f180af16f0d448"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e8f602973292ccc1cce175090b3f1dd2538e6d9294e99361357123f96c670c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a326c7bb5fc3f48a9e170559e73dd417aa8a9b4a5ca22cbd9f5d125b237f8d"
    sha256 cellar: :any_skip_relocation, ventura:       "31c07574a32037f1a1e7fef7f78b8d8d58b4ffe97764028d0a3dd8afdba5b545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f4ff378cd8d058f84f91ce71f9e52a64e4dee102f40999a53bc679d24ccda3"
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