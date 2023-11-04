class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3440000.zip"
  version "3.44.0"
  sha256 "ab9aae38a11b931f35d8d1c6d62826d215579892e6ffbf89f20bdce106a9c8c5"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff164d4dfa0b010951c4354f1258b66e5189365f85370070ef19c1f7dc50383e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f6805410bc62ad93d1c438ce5f71b1ece9c8946111f2f47c8ab57781027add6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2439612483c36d9995ba323f0b82338728de91a0af7b94b2fa41b20c5df9c985"
    sha256 cellar: :any_skip_relocation, sonoma:         "647b186e43c3b485cba6882d63b0a47c8cadadb19a11c6976350e585487ec246"
    sha256 cellar: :any_skip_relocation, ventura:        "94aca12245f0e3be4b5fb78a5189424520de0f766324b32f9b36863ca1897c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "b32212b644d6bfd227aa576442082ec42f210ad55f8a45cecc6b1b429f28453a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83eae1f8dc6f9e4936075a167a65d166dd16ca9528868727d7a22053b7ad9d9d"
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