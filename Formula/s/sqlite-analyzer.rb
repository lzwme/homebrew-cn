class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2024/sqlite-src-3450000.zip"
  version "3.45.0"
  sha256 "14dc2db487e8563ce286a38949042cb1e87ca66d872d5ea43c76391004941fe2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3eb9a9aae9016b500046c60aeb0e1af984c8a913c9840afe121e22b4112d0eb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e87550fcc3d3f7c9fe2af6dfb0ef67d99d5991b3f298f1a1e3c54a8fc3b4ca6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41585836fce4975d38061aadaa5e496c3dfa9074a9d9c29c0a891c976056e0aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f0ffb54412dd9bc2735362536e77b3cd728c5d169ddf6250defb6ffafbca47a"
    sha256 cellar: :any_skip_relocation, ventura:        "556a8e0143066475294a03c7175d7857ae908743838a60a54652fddcfe23defd"
    sha256 cellar: :any_skip_relocation, monterey:       "87f9d92b0420b3f93cef9eea3122fb7cb365268f0efecb1589aabe847e35a575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c811aa7d751a775c39dddf8e2fc73e2ee3359c4f1516c7a3fc445aba2a7a9108"
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