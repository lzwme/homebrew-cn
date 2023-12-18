class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https:github.compaullouisageneaulibjuice"
  url "https:github.compaullouisageneaulibjuicearchiverefstagsv1.3.3.tar.gz"
  sha256 "b260d5b9247f6c6a4f1651914e4bd2876fc885159bd16e68e8acd4acdf8ff11c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a960bb497199226422c11750222c28fa9791e8afe8e75b3ff9dff881b1c28a6"
    sha256 cellar: :any,                 arm64_ventura:  "8bc0e4b2ca1f8241d9396694507487e24068d814e41daf5a848ef15f4975ed0e"
    sha256 cellar: :any,                 arm64_monterey: "1853a8aff6421c8ed4f02d5fe72aafdfcbe47fc86ba0502d7bd801f1a741b545"
    sha256 cellar: :any,                 sonoma:         "d2bc7594eac555715ba4020e0fc16d9f15eb7cd283ee23396f28314526db1a25"
    sha256 cellar: :any,                 ventura:        "f755123f57a4e44b15ea950b02ba12208d4fb265a4dec608a7e6ce53cb4f0c01"
    sha256 cellar: :any,                 monterey:       "0d3fb8dd34b0307b2fd24704ee98eab1bc02d791de0ce548505eab57e598b49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7aa7dab95f02da4817169893eacd618b9180373c1625ef79a9068c9a40ce55c"
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