class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://ghproxy.com/https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "ea30b4f10b3ea7e4a816f50eee37a6abc5cd9f45c90ab69a9110fefe5d1d89f0"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "11880982fdb3c6a93b180402af8bafb598b9420ff10fc436d411d0a89d51665e"
    sha256 cellar: :any,                 arm64_ventura:  "fc4eb03177a6ec79935663be31677d1ed7bbd2bf7029a1123263e3b86ed5f4ef"
    sha256 cellar: :any,                 arm64_monterey: "2000bdb0b8bb05b7ee96daa25470a256dede98bc0194f29decf4e0da703fd7fa"
    sha256 cellar: :any,                 sonoma:         "39a87d96ad70c58942289dc83f7174ac6f0dcc3d8fb8bd8cbf1a712f2d0fb716"
    sha256 cellar: :any,                 ventura:        "5e7fb58798a4544cbf5fb59ad3bd3282d4d3a4286b6fbce0cd9cba98872403d0"
    sha256 cellar: :any,                 monterey:       "a2d259fc4653a1e85d904d5025b1a864f9be6f7913142fe891f47e662d119ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f5643e873c54d9b3c8e47049c931e074466f75a5f83e298340b4549b8e4e8d"
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