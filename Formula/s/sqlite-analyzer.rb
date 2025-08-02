class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3500400.zip"
  version "3.50.4"
  sha256 "b7b4dc060f36053902fb65b344bbbed592e64b2291a26ac06fe77eec097850e9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e8f648f174b1c820f49e926b0b72232ea62753c13c7ed3b399940435bee7dc4"
    sha256 cellar: :any,                 arm64_sonoma:  "c082ffe72e06051e9643e26936e640466836992fc3dd27608e23e570fe5e0151"
    sha256 cellar: :any,                 arm64_ventura: "29be04dc1dbc47c0f16c96765389d9dd81530bd1c17b27a05058ee1aec254024"
    sha256 cellar: :any,                 sequoia:       "dd57fd9f41ef2bfe9e21f7f00185a818b45c03f4b84e42e7b3b3378b6b046e11"
    sha256 cellar: :any,                 sonoma:        "4ea08b67282f32d4e657301b6d0fdfcf50acd3ee2b3406a4ec783c847a113cdd"
    sha256 cellar: :any,                 ventura:       "91030d1ca9685939bc35f65fb7ab65d5c34655b3cba243eb32c4b3a1a80880d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc80e06640fead3520cf6623e6385bdf7065defce848d8c983c7e06b4c625d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84bb4ebf263f3e396a44870a6510a14688f203927f196199d81e72c00e66e0d5"
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