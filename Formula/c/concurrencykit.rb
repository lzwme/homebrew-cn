class Concurrencykit < Formula
  desc "Aid design and implementation of concurrent systems"
  homepage "http:concurrencykit.org"
  url "https:github.comconcurrencykitckarchiverefstags0.7.0.tar.gz"
  sha256 "e730cb448fb0ecf9d19bf4c7efe9efc3c04dd9127311d87d8f91484742b0da24"
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
    sha256 cellar: :any,                 arm64_sonoma:   "52db982710afc7be4787f7d4d739517a28d8b92e6e016292d4700d2164e07797"
    sha256 cellar: :any,                 arm64_ventura:  "e5dd4b47a7200e0179e740bfa48f34fa0194263e038020b97303e9b2f7cc93d7"
    sha256 cellar: :any,                 arm64_monterey: "b2d070df1dd5cad29f20b6a5192c2683086af490bd768a3b698e0fddb657cc2a"
    sha256 cellar: :any,                 arm64_big_sur:  "fad8ab6678349a6ae3a81ba7a8264591868f8c180c867f06ad98cb422d9627bf"
    sha256 cellar: :any,                 sonoma:         "bf7d287996890d9dd003f6702950d7e2ff25e42e64c0e286d60886bb411139cc"
    sha256 cellar: :any,                 ventura:        "5543bda088a7d54b530aed705e22028a9c6a6bc75da68bad81c0afbf4b4d4b12"
    sha256 cellar: :any,                 monterey:       "f5ccb2c540ce46a669ec5960ecdeb4f92e8eaa7c8e0bd889d0bc2a11474f2ac3"
    sha256 cellar: :any,                 big_sur:        "2834fffaf1b10eb3ee40fa9f01bfbe72a5df37161cbf78f8dd016f73aaf16966"
    sha256 cellar: :any,                 catalina:       "12788eda54c82375102f2f33e28f533151b4d3f6fa9042ea7c7aa03fb25c3e3a"
    sha256 cellar: :any,                 mojave:         "357062d84adf8f0c8d1a92a7fda6fb9278b6264edf061935d595342e0c334aed"
    sha256 cellar: :any,                 high_sierra:    "c8def7655e173d45ff8ec94bc78750507235fa9eb8b79be639bf250698d59761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5723a7d3a790bb1e7445f6bc753187ff939c57721a98c453c9539045fd3824ab"
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