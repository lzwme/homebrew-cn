class CassandraCppDriver < Formula
  desc "DataStax CC++ Driver for Apache Cassandra"
  homepage "https:docs.datastax.comendevelopercpp-driverlatest"
  url "https:github.comdatastaxcpp-driverarchiverefstags2.17.1.tar.gz"
  sha256 "53b4123aad59b39f2da0eb0ce7fe0e92559f7bba0770b2e958254f17bffcd7cf"
  license "Apache-2.0"
  head "https:github.comdatastaxcpp-driver.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d7789edcadff5905b4108444595d617ff24e99d54a7014afc2ce5c1a8d64c95"
    sha256 cellar: :any,                 arm64_ventura:  "4b26c05be9b460b2359176859b9a4949d7f9d675f2ac9a3bf729e21c3dc5edc4"
    sha256 cellar: :any,                 arm64_monterey: "c1589d2e2cc229a10e1d87e94612bbf55b9bdd4ab079a06563ce766b103c2c42"
    sha256 cellar: :any,                 sonoma:         "b02aef7c39651dd641588be99ffbd45d1febf4bd79acf506c26934a1582fe387"
    sha256 cellar: :any,                 ventura:        "4febd908b491a13787addbec6dad2dc98182f0d45cead041f8a493f0938f565c"
    sha256 cellar: :any,                 monterey:       "dc2ad2c4d0153746a2ca9f50525d95e1b45c25a4c3a4b19c0525b6522f261f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "566d29b795409300c8444c185f335a91df5f05bfde6dd303d12154bd83b6ec6b"
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DLIBUV_ROOT_DIR=#{Formula["libuv"].opt_prefix}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <cassandra.h>

      int main(int argc, char* argv[]) {
        CassCluster* cluster = cass_cluster_new();
        CassSession* session = cass_session_new();

        CassFuture* future = cass_session_connect(session, cluster);

         Because we haven't set any contact points, this connection
         should fail even if a server is running locally
        CassError error = cass_future_error_code(future);
        if (error != CASS_OK) {
          printf("connection failed");
        }

        cass_future_free(future);

        cass_session_free(session);
        cass_cluster_free(cluster);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcassandra", "-o", "test"
    assert_equal "connection failed", shell_output(".test")
  end
end