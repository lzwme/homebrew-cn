class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://ghproxy.com/https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "be806967ff4dfa80d88d2197cabd8a5bf0072d03759bf8506aaa4ee9c5c48ba6"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cc547f6e172dce904661b25d848f111fbc7099894c2afa02d8291f283feafbd9"
    sha256 cellar: :any,                 arm64_ventura:  "5c734f483db1b13af183e10d76996796a215efe9f2b32d990724fa4bb724e871"
    sha256 cellar: :any,                 arm64_monterey: "507d8378c3cda9ea98d9bf8e524ffec7afcb8286e309849f978d1198420acf89"
    sha256 cellar: :any,                 sonoma:         "23ab5c422b1ec659fd2fd2bdf630f6db5ad375b955820836e8759d64cde2c1f3"
    sha256 cellar: :any,                 ventura:        "cf4321672ede78c5499b33d6ff6bff3a29c80aa45db13cac3a2ac2a77d736bfc"
    sha256 cellar: :any,                 monterey:       "eeff914da5569d7bd4d9ee992b2ee325db6e75accfaebe5241edbdf89b120a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4967be8f8baf0e5ccf3c67f5717e685c78bb6955a7a9d6346bb5741e9f5e0849"
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
    (testpath/"test.cpp").write <<~EOT
      #include <wolfmqtt/mqtt_client.h>
      int main() {
        MqttClient mqttClient;
        return 0;
      }
    EOT
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwolfmqtt", "-o", "test"
    system "./test"
  end
end