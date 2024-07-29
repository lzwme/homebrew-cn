class Tdb < Formula
  desc "Trivial DataBase, by the Samba project"
  homepage "https://tdb.samba.org/"
  url "https://www.samba.org/ftp/tdb/tdb-1.4.10.tar.gz"
  sha256 "02338e33c16c21c9e29571cef523e76b2b708636254f6f30c6cf195d48c62daf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9854a37572f7cce1f448d9b2d53ef32dc86ca6746a5406a0df5af3801d8ad32"
    sha256 cellar: :any,                 arm64_ventura:  "9914f2f8ccf8a58372c60590dd844d5a0cf79b61d0cbee2040e3407dbf8fbdb9"
    sha256 cellar: :any,                 arm64_monterey: "9a81bdad8cbb3a5ba628f28dd5d6617baead092d36cdf29f0b764032765e1653"
    sha256 cellar: :any,                 sonoma:         "3eb323351c0f53d0c2810f67e7e33c601d7d62f86391f8294a6761f9ce87c980"
    sha256 cellar: :any,                 ventura:        "d318e91f29256bbda8de95502efa882ca3a8ee11b59267064b401e0e597c0a4a"
    sha256 cellar: :any,                 monterey:       "9b0f8a5fa84b0e399b0b13bad3c50f03a4497365f548b8b35741df58ed6ba15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1853e3b8ce6cb7864c6fac6424c4ab9e284c6e2c0775189fac023477b67298c"
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