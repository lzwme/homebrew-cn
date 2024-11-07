class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https:github.comwolfSSLwolfMQTT"
  url "https:github.comwolfSSLwolfMQTTarchiverefstagsv1.19.1.tar.gz"
  sha256 "77031b151092e8506d7c621f5e12e79531edca2336edf23146d3d72c70e6557f"
  license "GPL-2.0-or-later"
  head "https:github.comwolfSSLwolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbeff7e907d0719831941f1e1b4e709930024207478c93e11ff0a3194f6cde1d"
    sha256 cellar: :any,                 arm64_sonoma:  "3f814c921f5438322bd54832c98069c1ac4d50ea6b5ca58787d64fc1002b0f62"
    sha256 cellar: :any,                 arm64_ventura: "2eab6f9adee55fd00b3cc5cc826dff904aaa94cca866f0983652f5a630c3eae1"
    sha256 cellar: :any,                 sonoma:        "4291b1d831cd6f120584f94fa022db225f835243b83367ac885cbeeb61771734"
    sha256 cellar: :any,                 ventura:       "e16b19bffb634c40548f376d34dfe7745a6392b33601d0a036194550bbdbb463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d204910c1af446127a29672a244f5dbceaeddec303b57387b1774393e9ec9d"
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