class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghfast.top/https://github.com/aws/s2n-tls/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b62c52ededd0b42e58fea660727141728cfb853c564083dbfc6fd027a1564582"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "961c46d7d33c628c162307be158faae67782822000a3e01ba988ad81cfbc5b28"
    sha256 cellar: :any,                 arm64_sequoia: "54235155349bd2f732dc7bcf996086d1b7db2ebe6b8976729d104685a55b4130"
    sha256 cellar: :any,                 arm64_sonoma:  "2ee4c0e00795cb0faac9969fde49991c28c74b3469f362c5ddea796c018f6fd3"
    sha256 cellar: :any,                 sonoma:        "deda042e4641b8fb290d0272e8d291cb151d1019c1795ebb75501599ad8dfa42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d29b061028a7bd373b0ccbfd7318971e34af2efc27a1f6116863719473b15ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f98d7cbfc6d0f1e1eda1a81d08fec377af2cb96d6da535cb8a2b4cbb54f14f98"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end