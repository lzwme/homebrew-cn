class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://ghproxy.com/https://github.com/redis/hiredis/archive/v1.2.0.tar.gz"
  sha256 "82ad632d31ee05da13b537c124f819eb88e18851d9cb0c30ae0552084811588c"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "9970a5ff45d25be488b5f3e843fb777624b4824510d8434b23565fc9b703a59a"
    sha256 cellar: :any,                 arm64_monterey: "bf180f8a975c907210d5c130be249f21a9cc050710c83acc9dd6b699c398ae24"
    sha256 cellar: :any,                 arm64_big_sur:  "f1d1112d4969beb75a30b43faa1fb953f0b869ffe5d9dc02af2f16780abe34ad"
    sha256 cellar: :any,                 ventura:        "ca336f556d8c10e7cfae516c8e6d5333f5e55533d0971e68f8ed2a730bb765fd"
    sha256 cellar: :any,                 monterey:       "33a1ced3df2be2279bb716e924f948d1be77f3dc3f831880900655f71daf2e95"
    sha256 cellar: :any,                 big_sur:        "de9df908dc8e52a552d1f6faed0bc839750f44aad97666d835dd0f7634e3e051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8c2054cf967b075da6153fea843f3b48e285213aa5944aab4d4b6e14e650bb1"
  end

  depends_on "openssl@3"

  def install
    system "make", "install", "PREFIX=#{prefix}", "USE_SSL=1"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, pkgshare/"examples/example.c", "-o", testpath/"test",
                   "-I#{include}/hiredis", "-L#{lib}", "-lhiredis"
    assert_predicate testpath/"test", :exist?
  end
end