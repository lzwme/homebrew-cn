class RedisLeveldb < Formula
  desc "Redis-protocol compatible frontend to leveldb"
  homepage "https:github.comKDr2redis-leveldb"
  url "https:github.comKDr2redis-leveldbarchiverefstagsv1.4.tar.gz"
  sha256 "b34365ca5b788c47b116ea8f86a7a409b765440361b6c21a46161a66f631797c"
  license "MIT"
  revision 4
  head "https:github.comKDr2redis-leveldb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c4f724a8e484fe6949b3733a7c1d4201370dabbbbd3b5e4a7e4b4312a06bba7"
    sha256 cellar: :any,                 arm64_ventura:  "8ed6a3bbc7dcfb695d7d133bb5f87eb564288e0f1ab221099449b1dd4f8bbabe"
    sha256 cellar: :any,                 arm64_monterey: "6ae884a362ca96df3f67994461b0732d305e7dba323598dba029338a11d10cf3"
    sha256 cellar: :any,                 sonoma:         "edac4282df53a53882efe10586ee1d39c06b3f03f150d128f6acfa115c039cf8"
    sha256 cellar: :any,                 ventura:        "8eec3d30dde80b6f32de4c1167cad93bc2c6b95e9c7c65b017320e487b19975d"
    sha256 cellar: :any,                 monterey:       "385b411fac0e4374c3b61f952e09f0266a9a13a23bb12c91cb1209ff99547012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6323dd8c468b9cc40d9310fdeb776de380e1c32c622e682713dd98a9cf42e659"
  end

  depends_on "gmp"
  depends_on "leveldb"
  depends_on "libev"
  depends_on "snappy"

  def install
    inreplace "srcMakefile", "..vendorlibleveldb.a", Formula["leveldb"].opt_lib"libleveldb.a"
    ENV.prepend "LDFLAGS", "-lsnappy"
    system "make"
    bin.install "redis-leveldb"
  end

  test do
    system bin"redis-leveldb", "-h"
  end
end