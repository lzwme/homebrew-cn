class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https:github.compaullouisageneaulibjuice"
  url "https:github.compaullouisageneaulibjuicearchiverefstagsv1.5.6.tar.gz"
  sha256 "9a70c7221e6b2175ffe9b4c6e97acf199d0649d718e1f9b837d6b46533dc9702"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "045ae8fb28a204633c9cd217fc5b655b5b89cd00620a48d00dadba5a121b60b4"
    sha256 cellar: :any,                 arm64_sonoma:  "a88948ba24da4030b9852ac750443f2f7e1780c6cae94a079291e5bb58ac4954"
    sha256 cellar: :any,                 arm64_ventura: "7e74e37319e0a480f14c62ef2e2d9d4f1937bb1c764acba79990584e05cbaf32"
    sha256 cellar: :any,                 sonoma:        "214358735ae1a917db3ad24de2e12d2c6202d8437bed51f53f789ad1835022d4"
    sha256 cellar: :any,                 ventura:       "776283cf6ecf9984029ecc86515708c1d81f04fec34f4933f38855823263b412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28e1b09fe9ac801520cf1340428ac7743681ed64865ec166ef21a579b14a1cd3"
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