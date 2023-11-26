class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3440100.zip"
  version "3.44.1"
  sha256 "52aa53c59ec9be4c28e2d2524676cb2938558f11c2b4c00d8b1a546000453919"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45f4d16c90f1f232aa26ba19644784a4926bd416e240716b9ea9b2ef513217c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b6010e07632a6d24b6b6bec61001a2258d24811bd4d0f9292b48f167c95600a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd56e208be6e94c670c227ff92bc19b62b71fa21975836c8e38bc819fbe11559"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dae4d9506de2bc03bd871fe64ab01e9a7255c8bbb964ec74f3abb3cb133c250"
    sha256 cellar: :any_skip_relocation, ventura:        "23a423582ed32c63bb7392519a56105a8f60795122845375ad49c0efac30f373"
    sha256 cellar: :any_skip_relocation, monterey:       "ccb05ac0bb992d6b36b24f4605392f2fb177923fe36c3cee556a46ac45aa016f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e381c8a957d14dbab47a360dc19194cad25e19882c3ff563477d5508096baf7a"
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