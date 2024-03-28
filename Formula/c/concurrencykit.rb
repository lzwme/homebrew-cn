class Concurrencykit < Formula
  desc "Aid design and implementation of concurrent systems"
  # site not accessible bug report, https:github.comconcurrencykitckissues225
  homepage "https:github.comconcurrencykitck"
  url "https:github.comconcurrencykitckarchiverefstags0.7.2.tar.gz"
  sha256 "568ebe0bc1988a23843fce6426602e555b7840bf6714edcdf0ed530214977f1b"
  license "BSD-2-Clause"
  head "https:github.comconcurrencykitck.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "61349da656422bd19044368a9dd6a07e9e6a45e77e301baff35e8af1a8331087"
    sha256 cellar: :any,                 arm64_ventura:  "0a0a6868102744de167a27d8ce774ac1542b268713588998879cc782ce7d0f50"
    sha256 cellar: :any,                 arm64_monterey: "2b96f7b0f8b586812621ca5711c4cc59d4916e69658ff7b95c11166730611069"
    sha256 cellar: :any,                 sonoma:         "d94a55b7f88f9cf03147ec862d25be282781c0c6fbcc6d2dbc1bd70ec0abfeb1"
    sha256 cellar: :any,                 ventura:        "e1adfa5622f3b5dfc3fe5832ae5a8b7241e914483654bbbd7dfc5fda4d90afa7"
    sha256 cellar: :any,                 monterey:       "9f009724d28dad411a65eae3aad260b7fdb26a4ea6d8fda2125b21350eff06ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae7af3262f13d4917f84f0522cc36cc8709e482f458067578c6e58f0a26737ac"
  end

  def install
    system ".configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <ck_spinlock.h>
      int main()
      {
        ck_spinlock_t spinlock;
        ck_spinlock_init(&spinlock);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lck",
           testpath"test.c", "-o", testpath"test"
    system ".test"
  end
end