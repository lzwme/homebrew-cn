class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https:github.compaullouisageneaulibjuice"
  url "https:github.compaullouisageneaulibjuicearchiverefstagsv1.5.7.tar.gz"
  sha256 "6385c574f3c33f766ed25cddf919625b0ae8ca0d76871f70301e5a0cf2c93dc8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed571298e95ec58f065403da6205544d42aec68ab14cf745d392ad495c098141"
    sha256 cellar: :any,                 arm64_sonoma:  "a3a260330d564ac730c45bfe88dac8c7da620a5034284d5dd1d64c1ef816afc7"
    sha256 cellar: :any,                 arm64_ventura: "72aa40c4dc361fe718e9afaf0af55e38b54e172832e13a115d36536013929b7d"
    sha256 cellar: :any,                 sonoma:        "7951d8fbcb03390b5d593a29b2539d561a943b15f6ba559078a2d5055e09010f"
    sha256 cellar: :any,                 ventura:       "bca10dda1797aafd614735076d368ceedc76bdbeca7c3d658ddc958104f3608c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc82c641d66d92d7688058d4401d4b4e0e105ff1baee5181ff9e665fdb519a79"
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