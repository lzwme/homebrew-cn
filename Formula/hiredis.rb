class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://ghproxy.com/https://github.com/redis/hiredis/archive/v1.2.0.tar.gz"
  sha256 "82ad632d31ee05da13b537c124f819eb88e18851d9cb0c30ae0552084811588c"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c61f133fb6de34228913494475637f1976b8d7311578268538213cce28694bc5"
    sha256 cellar: :any,                 arm64_monterey: "0ed597b4ade01cbd784219fcbbee73d81c3e19903576603632a08560611137cb"
    sha256 cellar: :any,                 arm64_big_sur:  "adf8907914fb1814873f22bc9dc8ebe27b7211d419cd99fdb6c3dba8dfb18438"
    sha256 cellar: :any,                 ventura:        "aba6e4ade87e762d170ba08d9d00c34b87c3edbf3a568d22a4f4ae66dccadba4"
    sha256 cellar: :any,                 monterey:       "bc8e03de800b74a5ab871a8eb7c5224d70815fa6d9a67cc4588b8e1310d6e48a"
    sha256 cellar: :any,                 big_sur:        "fedd1d479a255e40912c5000fa3c39885735b54da5baaed5f63b18daf907682a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab8246b1ea0825094a91de9209dc554a9a735c3fb3cb5c63b5475826ec941078"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
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