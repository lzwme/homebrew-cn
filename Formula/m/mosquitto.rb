class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https:mosquitto.org"
  url "https:mosquitto.orgfilessourcemosquitto-2.0.20.tar.gz"
  sha256 "ebd07d89d2a446a7f74100ad51272e4a8bf300b61634a7812e19f068f2759de8"
  # # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is pretty the same as BSD-3-Clause,
  # see discussions in https:github.comspdxlicense-list-XMLissues1149
  license any_of: ["EPL-1.0", "BSD-3-Clause"]

  livecheck do
    url "https:mosquitto.orgdownload"
    regex(href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77d22c193e73697f37d01baa7789335c3d388c151c1f038b0e8aafbd88c67d00"
    sha256 cellar: :any,                 arm64_sonoma:  "fc81a1301d899e772d87f00ce348dc53400b1cb0580c1cdbe359344a057ab2ad"
    sha256 cellar: :any,                 arm64_ventura: "3c13508206d8e4b688f60492469a0612903a5b44aeff34e3887c160296fb93cd"
    sha256 cellar: :any,                 sonoma:        "ef7cf0bd6b3360b6f78b13377119bf15388b755741e797938cead00d85bd7710"
    sha256 cellar: :any,                 ventura:       "0031f59b55e73707ea552805e074d870d98fb9b733ed743e426fca109e6e3d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "144a1795ae116095ad069cb19b17c83e5c1e6941c2c6f1bbcc755325264dff18"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_PLUGINS=OFF
      -DWITH_WEBSOCKETS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var"mosquitto").mkpath
  end

  def caveats
    <<~EOS
      mosquitto has been installed with a default configuration file.
      You can make changes to the configuration by editing:
          #{etc}mosquittomosquitto.conf
    EOS
  end

  service do
    run [opt_sbin"mosquitto", "-c", etc"mosquittomosquitto.conf"]
    keep_alive false
    working_dir var"mosquitto"
  end

  test do
    assert_match "Usage: mosquitto ", shell_output("#{sbin}mosquitto -h", 3)
    assert_match "Dynamic Security module", shell_output("#{bin}mosquitto_ctrl dynsec help")
    system bin"mosquitto_passwd", "-c", "-b", testpath"mosquitto.pass", "foo", "bar"
    assert_match(^foo:, (testpath"mosquitto.pass").read)
  end
end