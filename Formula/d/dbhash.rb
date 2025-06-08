class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500100.zip"
  version "3.50.1"
  sha256 "9090597773c60a49caebb3c1ac57db626fac4d97cb51890815a8b529a4d9c3dc"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d857f8ef40633f3be727273baf8bca859f5934bd2aaaa0f9bd5eea926f27773a"
    sha256 cellar: :any,                 arm64_sonoma:  "14669037bda9b553f55688291de1664c70176e2ea2ff2d96e537d848c9cd59c0"
    sha256 cellar: :any,                 arm64_ventura: "779a31b6a74abfdf461d8947b393da8e44c2b37711d74b34aed229bd88205934"
    sha256 cellar: :any,                 sequoia:       "5601db068d70dff2e0301bf6a2c42b5a84bada850ead51b8d96cdf09a3c12eea"
    sha256 cellar: :any,                 sonoma:        "353477d756faabe6980df7505f709349abbc812f26a3b16ce0dd5099b0048cf7"
    sha256 cellar: :any,                 ventura:       "e13cc185c539db6fd12f48040e0bf9cb6a68841f4357b06cedf6b687ea45e41e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6954c38097ba0bec211df2e1936372179951576fa4789877a0726db797ab3486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83570befa44495de8925a414797fc63a365015e6407c9569f3f3b60ee06e968d"
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