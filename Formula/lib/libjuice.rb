class Libjuice < Formula
  desc "UDP Interactive Connectivity Establishment (ICE) library"
  homepage "https:github.compaullouisageneaulibjuice"
  url "https:github.compaullouisageneaulibjuicearchiverefstagsv1.4.2.tar.gz"
  sha256 "5fc6c422c70b5bdf5a3a8ed8543bff295ebdcaf24efe75933c17bfe54f940559"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "315d0493ebf6f6febb53a8cc3442fc93b3d776acc9f803933b92e82a204e27b0"
    sha256 cellar: :any,                 arm64_ventura:  "1b9b8f30830d509cf1c507f4280d635a9be82dc94d112331be32465cdc085c60"
    sha256 cellar: :any,                 arm64_monterey: "a8e74cdd814aa0e1c4b1b16e02920b32a4c9ce3775c868ff2ad228cb1bb432f8"
    sha256 cellar: :any,                 sonoma:         "fb3fd86d8532fb2abcda6cea837f848917c9db32d69b377f7d06acdb52b1545f"
    sha256 cellar: :any,                 ventura:        "63242c44268500cca402b3ccdcbc94e692faf46674b3651ff65fe57079bb86a7"
    sha256 cellar: :any,                 monterey:       "83c62e435237a1ed7c402121a269f19d89003150125a5a0f3b073057fc37aec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "891d0d99582c8a99d16908ae92079e8128f2cc183229254c181455f9e3035e30"
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