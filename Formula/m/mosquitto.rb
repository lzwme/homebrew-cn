class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.1.1.tar.gz"
  sha256 "d93026a8f8255a32fe146ca77df5e26259b7947745370a3944a68ddb4ec663ff"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https://github.com/spdx/license-list-XML/issues/1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33020fe3eb26e4ff7c4ba0e65e5175ed6750cda378419a24c8be010c5dd901c6"
    sha256 cellar: :any,                 arm64_sequoia: "87e4b4f7e6c7b4b69a9fac130b1065b1596958d373917548648514ea24241d86"
    sha256 cellar: :any,                 arm64_sonoma:  "ead707b92cef90df7108714019e6c58611ee8cee1852e35499a9edf70518394e"
    sha256 cellar: :any,                 sonoma:        "829f489c8e3c9969a61751fafcd44a4120b2dc79a175438a0127c39074a9e205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27e1296568858dd80f9a3bfb3f2e68bd46f467076ac9b889464f76e5cd883aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e7362a745f5c479d285f11891325727cacd987369cd9847fcbe332820ee65d"
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