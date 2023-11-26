class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3440100.zip"
  version "3.44.1"
  sha256 "52aa53c59ec9be4c28e2d2524676cb2938558f11c2b4c00d8b1a546000453919"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5c20122d01e66e741b9151a435530b81c534849b422ae275ebd91553085b66a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75823f12b5da91b484ee3ef1ca14d2b8acea89565902f3f458983234060aca75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97b766f912330ba1e27561641b12de85bad83df904896fb747b926f45c42634f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4accd67ad521fc9856c407d9be8813e04b4cd84284b23fca799d1fb7b84d99ee"
    sha256 cellar: :any_skip_relocation, ventura:        "dd0143915f9908429d51db48f9d7a7959440c5b7b59051f06ed48419d9b4fcf1"
    sha256 cellar: :any_skip_relocation, monterey:       "c76dd14662ea45b9ccae531252aa2179cd2d83abe62e76bced2544fabb448472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a7479c32ad8bd2d5f82d0c1d381f28b4e6cd63062febc5b2501dbd1fa46d642"
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