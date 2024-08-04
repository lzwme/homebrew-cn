class Tdb < Formula
  desc "Trivial DataBase, by the Samba project"
  homepage "https://tdb.samba.org/"
  url "https://www.samba.org/ftp/tdb/tdb-1.4.11.tar.gz"
  sha256 "4e8ba6d93f383565bbd061be4deee15318232d1bbcca7212f18e17f56bb975a8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tdb/"
    regex(/href=.*?tdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "17f1b2e28c3bf5903f4c628e59fdded926080a7f0352dc9f90e9d387d8e9df9d"
    sha256 cellar: :any,                 arm64_ventura:  "baeaf2c0623b8843115b041c431d8145d2a101b6948a3dfd3fb4c75d2326f33c"
    sha256 cellar: :any,                 arm64_monterey: "d1dbde0051a48a15ba6b35b270047d1df087476e15d067e79b0f83fbb98f5b03"
    sha256 cellar: :any,                 sonoma:         "9fdbdd4ae45f962d1da2fcab6ecb2e8589a8d2fb70ff7cf48eec3d5ad61a79e3"
    sha256 cellar: :any,                 ventura:        "23d41c03b78ac0fa4ebbf70c5e528796fcfd12637205eca9437a98e59ac83b1a"
    sha256 cellar: :any,                 monterey:       "eed511b25c04a48b5643746b6dcfe676ab3259567c2255565f999de622e4fbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aff979411eb80e5bd16676203a886cee4f1348a1cdbdc799e43b5fedc3ba256"
  end

  uses_from_macos "python" => :build

  conflicts_with "samba", because: "both install `tdbrestore`, `tdbtool` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testdb = "test-db.tdb"

    # database creation
    pipe_output("#{bin}/tdbtool", "create #{testdb}\ninsert foo bar\n", 0)
    assert_predicate testpath/testdb, :exist?
    assert_match "Database integrity is OK and has 1 records.", pipe_output("#{bin}/tdbtool #{testdb}", "check\n")
    assert_match "key 3 bytes: foo", pipe_output("#{bin}/tdbtool #{testdb}", "keys\n")
  end
end