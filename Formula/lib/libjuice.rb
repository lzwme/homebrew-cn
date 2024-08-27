class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https:github.compaullouisageneaulibjuice"
  url "https:github.compaullouisageneaulibjuicearchiverefstagsv1.5.3.tar.gz"
  sha256 "8fe2408637cb62ddbc9e76712fd726ab312a9e2db5098d5736dd9cc958736481"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59c2321d621d93cb390aa99166d7d2b3663b1ce93fc42ecd362c394364a093f5"
    sha256 cellar: :any,                 arm64_ventura:  "ce12ede3040f39efcfdeff668ffcabaf84bf144a3be0c56fc82ebe335c4fb1bb"
    sha256 cellar: :any,                 arm64_monterey: "62e7fe9bc80206b235cee74654f4c2b5411b95b79778a8ae1dcc485cc048d028"
    sha256 cellar: :any,                 sonoma:         "8dcdce7e69a874c138958efcaa8697b87f83c991a9213d1e3759c85c0c8e0785"
    sha256 cellar: :any,                 ventura:        "c176d7a3ef43b2c34e6223d42f14ad6750fe63999135b5e09daf3626e681bbda"
    sha256 cellar: :any,                 monterey:       "3f322b1c1563e64e10138422ab99041c3656d5dbc11d09e78dda67e526ae10ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f114678eb35099431da27515f51b93e2274d24e7dfc0f1ea09ffa480748e55c9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DNO_TESTS=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include "juicejuice.h"

      int main() {
          juice_config_t config;

          config.stun_server_host = "stun.l.google.com";
          config.stun_server_port = 19302;
          config.turn_servers = NULL;
          config.turn_servers_count = 0;
          config.user_ptr = NULL;
          config.cb_state_changed = NULL;
          config.cb_candidate = NULL;
          config.cb_gathering_done = NULL;
          config.cb_recv = NULL;

          juice_agent_t *agent = juice_create(&config);
          printf("Successfully created a juice agent\\n");

          juice_destroy(agent);
          printf("Successfully destroyed the juice agent\\n");

          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljuice", "-o", "test"
    system ".test"
  end
end