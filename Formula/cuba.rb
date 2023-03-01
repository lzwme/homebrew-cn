class Cuba < Formula
  desc "Library for multidimensional numerical integration"
  homepage "https://feynarts.de/cuba/"
  url "https://feynarts.de/cuba/Cuba-4.2.2.tar.gz"
  sha256 "8d9f532fd2b9561da2272c156ef7be5f3960953e4519c638759f1b52fe03ed52"
  license "LGPL-3.0"

  livecheck do
    url :homepage
    regex(/href=.*?Cuba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "357899b8a6077f7f5da7bf4c50b77a6947515b6a8ba1dfbe1fd8a8297795afac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ce1fa8a1cf71b27ebeb02406214231dcafcab672b7c38bc5a664c9e2c69d424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8f141d10928d1ce281f6bb744886de1ba9f2274476d3b6b257bcc9d587231e3"
    sha256 cellar: :any_skip_relocation, ventura:        "7a6e2801aa15f48ce5ef6aa1c7c2d70a0eb05d9a95d9e75ebd1982dc23345d08"
    sha256 cellar: :any_skip_relocation, monterey:       "238e6efde7346d58330b4ebbe562a5f52375d66bd21555867883c3fe2c0405e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "897095ff3030916d5470e15f85ca3a0d0460416484232cc7c821dc6e98c4406d"
    sha256 cellar: :any_skip_relocation, catalina:       "566d4ddc7e4e3a278dceb6b83abc5ce1298b9ca715ac152695bf1e5fbb8cacc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d0398225a7a9364431992f44347ee9fad5bb3a049f5ed628aabb23bd405ed7"
  end

  def install
    ENV.deparallelize # Makefile does not support parallel build
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "demo"
  end

  test do
    system ENV.cc, pkgshare/"demo/demo-c.c", "-o", "demo", "-L#{lib}", "-lcuba", "-lm"
    system "./demo"
  end
end