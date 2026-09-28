class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://www.wolfssl.com"
  url "https://ghfast.top/https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "abfea53ef25678a540f9b44aceb4aeff3f7789d7b23454074471c8e8dbcb4ccb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ebc3c1b5b18b34218838255f3602649f45e8b33633ced2b31a302ee782be4188"
    sha256 cellar: :any, arm64_tahoe:       "d49f4693e1aecbcfe0543d9a95560a3d135456b564d1a6064dd5ee38127dae9b"
    sha256 cellar: :any, arm64_sequoia:     "ccfd7d918e37ade189bb82818c0b673c5bcb3a276dc255886d9396cdfcf542ef"
    sha256 cellar: :any, arm64_linux:       "8530cf463c9106e14cc6b072be9cfc77c8138fe13273ef2e91a0f6c11848947c"
    sha256 cellar: :any, x86_64_linux:      "acff17fb6292633caafcb05dea63bbc2bc02ee2209302ecc7d8e5543ff77b883"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wolfssl"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-nonblock
      --enable-mt
      --enable-mqtt5
      --enable-propcb
      --enable-sn
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <wolfmqtt/mqtt_client.h>
      int main() {
        MqttClient mqttClient;
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwolfmqtt", "-o", "test"
    system "./test"
  end
end