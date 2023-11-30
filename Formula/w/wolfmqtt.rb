class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://ghproxy.com/https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "c88e57aa9cf06d1b30bd8ebd1229fcc899fb1646e3af5873c6b8013180235284"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fe1e795bfa1676df99d8f6a240c7b167270b8cd3484a66ee60614807be6bca8"
    sha256 cellar: :any,                 arm64_ventura:  "0216c91c1fb8a40a7c606b92fcb7c7d16058371d633dd103c402cba8502dfb7b"
    sha256 cellar: :any,                 arm64_monterey: "b1ec7c37d19ecc2bfbe3175b7445bfe9c61371f98b52857023eae611b1ed6ab1"
    sha256 cellar: :any,                 sonoma:         "4b04911f047c343a8424a35498189dc019338b2b1b6ccbb6c25825ec80280e07"
    sha256 cellar: :any,                 ventura:        "de1fa19aee9b12a3e77fea452436fd7bbf7d5ce515c63075bc35dd544cb0f94e"
    sha256 cellar: :any,                 monterey:       "5bd32abbe0eb29c7d43abb53f28a8e6c50833aecf461dee744d61a942286d834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d2882bff4bf7bb8aa8f201bc5edbd683ac2ab281d6e427acb4af205fe47905"
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