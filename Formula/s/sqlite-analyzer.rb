class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3490200.zip"
  version "3.49.2"
  sha256 "c3101978244669a43bc09f44fa21e47a4e25cdf440f1829e9eff176b9a477862"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67cc3291707ff03543cd7dbf0b715f0f5401974dc0c922e0d98b01516028e20e"
    sha256 cellar: :any,                 arm64_sonoma:  "a454574109e0650c6a97eaaa1ccf74c0d97999fe4f7ef2a4f9323a6d4fe80cd8"
    sha256 cellar: :any,                 arm64_ventura: "6f141f8745b047a8a0c9c1242e649b6ff4a10cf3e74306ec8849d82b62df16ea"
    sha256 cellar: :any,                 sequoia:       "6596e7af88be2d70ad921d0438ae32f48775af94c79ac73b8f57f41198846ab0"
    sha256 cellar: :any,                 sonoma:        "472ef3a7bca1791cd68980a792fb08218a77b149de4441d375cedfb6aee2cb15"
    sha256 cellar: :any,                 ventura:       "43d649c1b152794475d0a69aaf8db30b82db957d471fc7642fe35305b1d9684b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e5c92aaf3c647f76266750f705a223b9b5826c081c00f3c2495871070916361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3371b2d5811117f606857e3f0ddb826affa2c2c140e8738e86037257eff2286"
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