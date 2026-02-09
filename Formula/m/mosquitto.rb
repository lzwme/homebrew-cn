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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2d9e7cba8a63477ccc5dcaa4638ac3256235b763f2464ae654d5142e682f8ca8"
    sha256 cellar: :any,                 arm64_sequoia: "8cfee425686221080e66dee41772eaa97841b2695a2febc29b7db93456d189ae"
    sha256 cellar: :any,                 arm64_sonoma:  "245d67c69be4c318ec9f485f3008acf071b3d9361fcf68353a0064c66e999397"
    sha256 cellar: :any,                 sonoma:        "bfa3f63d186ff50db4e7f8571c008b83381710225e0ac96a1398a92f168a5e4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7faa803fc0bf714081deffa4d0ea923cc9bc20827ed37f29fae2ad0ea9bdcf05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "978f73f5fa7ecb16d00fc633cca25d4a991af7ecfdb98b79e5900a2b75a055b2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build
  uses_from_macos "libedit"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_PLUGINS=ON
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