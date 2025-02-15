class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https:github.compaullouisageneaulibjuice"
  url "https:github.compaullouisageneaulibjuicearchiverefstagsv1.5.9.tar.gz"
  sha256 "952c9ae86491e1b7920e034281759a16158525e56e3dfa07060aac2532c77c6f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "841d199a73da93f066285b3795d984badc69b0e12981caed84228af28a2cb126"
    sha256 cellar: :any,                 arm64_sonoma:  "aafc3541a80281ee7eb230c3ca08a30bdf306f17f204e0e9a6d2163b7930c403"
    sha256 cellar: :any,                 arm64_ventura: "b95c9ed61269bd48ebb7ed28b1cd9c4a0a92d52f2e9272d22f55f7b04fbdff51"
    sha256 cellar: :any,                 sonoma:        "fd0d5f8183ef6793008759d51fc7213c7318a372635f7588d0e893904ff72064"
    sha256 cellar: :any,                 ventura:       "4352bd91de5dd4450da0e2f3edacecd0ade28479ed54d37a7bdea9366d4939ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd63688db47b13c70f4de6e006c86df8e856cb78b8cc5a55042d3e7d237a62f3"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DNO_TESTS=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljuice", "-o", "test"
    system ".test"
  end
end