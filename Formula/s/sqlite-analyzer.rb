class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
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
    sha256 cellar: :any,                 arm64_sequoia: "1271253eccadfdf5b407ce2a7c9138fe9480b8f7b860ab31d2f8967362f82401"
    sha256 cellar: :any,                 arm64_sonoma:  "e1aa92c0ddcb1ad0e2aa4afd33ffb05669e18850760c522810989aac2b8ff760"
    sha256 cellar: :any,                 arm64_ventura: "e9a682bc3873d7d40045c49925e3176cf120fea8bbe4447594cff7b92e86277f"
    sha256 cellar: :any,                 sequoia:       "8f2f335901fbf3654d646213695fb28d04b4ec71880f39aba943fdcdc43b962d"
    sha256 cellar: :any,                 sonoma:        "cc999d7fb26cf016f409223ad4be814824b622fdc08baaf91b6e1e48f7ad2785"
    sha256 cellar: :any,                 ventura:       "eb472725a0d2be49e0c5648016881c5ff8c694af7e96f010c34cda386778053f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "653388b0e9aed6593f9e70e02435ad6accf3069eea7f502eb2ef2aedabe29ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c04d8c6f16e18a462a5e180e5abad229eb1a48981e9d3844386fb8761e8f9b30"
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