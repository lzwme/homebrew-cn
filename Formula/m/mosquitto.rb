class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.1.0.tar.gz"
  sha256 "ceccf14f43b8ce21312d0dbf247025b8166536e9afba326f8b7c8b1d201fa6d9"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56833e00c438d915d0c880a4c39fd56d37e1e0c1916ad3053fda88b76d51e124"
    sha256 cellar: :any,                 arm64_sequoia: "171185fd38c7da7f7547af2609a8cee0e5d4b1f15fc99cc3dd4299d364b4211d"
    sha256 cellar: :any,                 arm64_sonoma:  "0b8d89d53fa7b7cbb3fda4ce6e0014f21f50ed35ef436a524751848892817488"
    sha256 cellar: :any,                 sonoma:        "4f5664e36b10786e90b8642c48fd612a72e4b9f7766742f3596fdce80f047f5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a1d550d24d1d3116641a618cc21c97498d6cc5ffa3ccdd046bdda95e8a96bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "657c6e39d6d021d193249ff3c1ecdf3193043a5bacc55aad1baeed0039988873"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_PLUGINS=OFF
      -DWITH_WEBSOCKETS=ON
      -DWITH_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (var/"mosquitto").mkpath
  end

  def caveats
    <<~EOS
      mosquitto has been installed with a default configuration file.
      You can make changes to the configuration by editing:
          #{etc}/mosquitto/mosquitto.conf
    EOS
  end

  service do
    run [opt_sbin/"mosquitto", "-c", etc/"mosquitto/mosquitto.conf"]
    keep_alive false
    working_dir var/"mosquitto"
  end

  test do
    assert_match "Usage: mosquitto ", shell_output("#{sbin}/mosquitto -h")
    assert_match "Dynamic Security module", shell_output("#{bin}/mosquitto_ctrl dynsec help")
    system bin/"mosquitto_passwd", "-c", "-b", testpath/"mosquitto.pass", "foo", "bar"
    assert_match(/^foo:/, (testpath/"mosquitto.pass").read)
  end
end