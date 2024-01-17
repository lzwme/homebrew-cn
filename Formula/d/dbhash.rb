class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2024/sqlite-src-3450000.zip"
  version "3.45.0"
  sha256 "14dc2db487e8563ce286a38949042cb1e87ca66d872d5ea43c76391004941fe2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2616bebbff56ffe64e97233f0a1c8aa76490a8212588fb93939a040f119087ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "245f98b8cec43e4c9d844010cb88563ff9e73bbee454096ee5395d1ea43d0822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d683b487d7463327b99bc801080b5966cab175654bcf029f98b919ea96488db"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca1cb111d0bad338816e42a42ee8e6e7c58d1db5434e69c8b9bef3f676893e40"
    sha256 cellar: :any_skip_relocation, ventura:        "5a63b75ef332b937cf81db49300049ae81b7192685a4abd353e448f5417c1ad9"
    sha256 cellar: :any_skip_relocation, monterey:       "7ae40b9b3a5a4fb95fb63fa4b3560d13bb310bb6de00807bac977ca0d448e8da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3c246751492635fa5d05a22072f520259d7598ed84179c8116ee3835cd28bd3"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end