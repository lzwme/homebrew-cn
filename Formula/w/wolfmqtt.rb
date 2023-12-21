class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https:github.comwolfSSLwolfMQTT"
  url "https:github.comwolfSSLwolfMQTTarchiverefstagsv1.17.1.tar.gz"
  sha256 "c88e57aa9cf06d1b30bd8ebd1229fcc899fb1646e3af5873c6b8013180235284"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.comwolfSSLwolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f449e013616248cb6930b0a42298b2a3cfcfd54446f49a8832cf54fd41392cb"
    sha256 cellar: :any,                 arm64_ventura:  "8a8d9ce198c5d4f7aeb239121d310d82f53a8fb41343f80d44f04d215a60b4a7"
    sha256 cellar: :any,                 arm64_monterey: "ca67d483b25a05859d3cc418c916e17ea6938b0a6c2b1ed021661cb829f21725"
    sha256 cellar: :any,                 sonoma:         "52e3649b91fd5a227aaf112a69484eb0963fed00aced089a1f0a4fbb6966e719"
    sha256 cellar: :any,                 ventura:        "fe486222379e937da65a46f62de57606b980e0680e8323e6301dd95b3982e0d7"
    sha256 cellar: :any,                 monterey:       "86ef91f62e529946aeabe1d3bf6a6aec595a3747868a44792960d9891f33cf99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "859f76ca4299890825a1bcd1f4a0818134d116403592f0576b97719caaf06aa5"
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

    system ".autogen.sh"
    system ".configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~EOT
      #include <wolfmqttmqtt_client.h>
      int main() {
        MqttClient mqttClient;
        return 0;
      }
    EOT
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwolfmqtt", "-o", "test"
    system ".test"
  end
end