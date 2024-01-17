class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2024/sqlite-src-3450000.zip"
  version "3.45.0"
  sha256 "14dc2db487e8563ce286a38949042cb1e87ca66d872d5ea43c76391004941fe2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b78f10b78225fce513fec9059786e6faf81df6c958f20e5c467f66d17343fd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "beeafc2bb81d239e18cd4028e9ea26bcfa82020563c886bfc12e1025a558a077"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4c9b86dfef503531ef4d1c77f9c161567fda3a93759ded09ceda3204179f26b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6d6e7c4cedfb40481d09471959d5781278f06ad4888a48f128398dd16dab4d0"
    sha256 cellar: :any_skip_relocation, ventura:        "f2f7e59ba8180f3273520c29fba1edec08cf016ff9a8582094608f2b0de56e79"
    sha256 cellar: :any_skip_relocation, monterey:       "799c89d1c9799c83e9c2dc71b2bdd6a29f1660e66e792b57f06107fd2ee6363f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33cd4ef5f3c07e0e3a55363a83ad1155d0888c6de4501c1e526ef0c60eee7184"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end