class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://ghproxy.com/https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "2fdbd3c9c07e86cf4cb0eba91f8f3b542d5f3ddefb18c2844d81af8ca37b24db"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bd87d77b2fa178f0f9912410e93b7fc827a28ebbbfb022acd14432cf4f998713"
    sha256 cellar: :any,                 arm64_monterey: "0cb7d339445b3da844fe7ec8c2b3f2a0f8667dbd62eb51dba27d55061e02569c"
    sha256 cellar: :any,                 arm64_big_sur:  "4e51129b096e6c16da80766a8e3fb30c30f89219c08fc800ab15a346c53f4874"
    sha256 cellar: :any,                 ventura:        "01d4af5c39e32e9f3f93614cb3397caf5de3aab1369d534401f2501e53b56e20"
    sha256 cellar: :any,                 monterey:       "309c2513f3fe7ac18ffbd28f3c9383d3c6cdf0db09ee09ab4f51c1410a4f2e62"
    sha256 cellar: :any,                 big_sur:        "beac741f17362a25dcc9644cc7be75b4eaedbcb504bfa45e538af211c57ddc50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aab9cc1dfc2adb756d6f89a68cfcac402ab6d3df70145d90cb8d806d17826d09"
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