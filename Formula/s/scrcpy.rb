class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https:github.comGenymobilescrcpy"
  url "https:github.comGenymobilescrcpyarchiverefstagsv2.3.1.tar.gz"
  sha256 "76f38779f00d91d0b46a399ebca32c82ff1facdbd843871b7e46c2e7cad38a42"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "2622646af93ea507ab817f69966c67fb13a87c8e6a4dcb58a25b84054e1399d4"
    sha256 arm64_ventura:  "d4f260af82c6f6b2a293ce68dbb246d205c5a0c03255ecb1c6ffa9bb0a3a6c59"
    sha256 arm64_monterey: "843f9da5d4a9e3bbe6f8a112c79d90f51eb72646f3fa861c80d1cee31599b2bc"
    sha256 sonoma:         "436d404489fd28c4bb9f5eb3c95f584da0e25915853c3a126228838f78f7f760"
    sha256 ventura:        "056862154ea1e0f6a2c44573a8b1a94a13783973b1f6b37f1c422160357a04e2"
    sha256 monterey:       "60c11828a8319edd6c603ff6b2cbe813bb4f2909d9b3f6d155e209cc22f97b1d"
    sha256 x86_64_linux:   "0c6fec4536fc30c03c8e1ed268505ae310e10fbec8882c22f8d6a2723d21b5a0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https:github.comGenymobilescrcpyreleasesdownloadv2.3.1scrcpy-server-v2.3.1"
    sha256 "f6814822fc308a7a532f253485c9038183c6296a6c5df470a9e383b4f8e7605b"
  end

  def install
    r = resource("prebuilt-server")
    r.fetch
    cp r.cached_download, buildpath"prebuilt-server.jar"

    system "meson", "setup", "build", "-Dprebuilt_server=#{buildpath}prebuilt-server.jar",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    assert_equal version, resource("prebuilt-server").version, "`prebuilt-server` resource needs updating!"

    fakeadb = (testpath"fakeadb.sh")

    # When running, scrcpy calls adb five times:
    #  - adb start-server
    #  - adb devices -l
    #  - adb -s SERIAL push ... (to push scrcpy-server.jar)
    #  - adb -s SERIAL reverse ... tcp:PORT ...
    #  - adb -s SERIAL shell ...
    # However, exiting on $3 = shell didn't work properly, so instead
    # fakeadb exits on $3 = reverse

    fakeadb.write <<~EOS
      #!binsh
      echo "$@" >> #{testpath"fakeadb.log"}

      if [ "$1" = "devices" ]; then
        echo "List of devices attached"
        echo "emulator-1337          device product:sdk_gphone64_x86_64 model:sdk_gphone64_x86_64 device:emulator64_x86_64_arm64 transport_id:1"
      fi

      if [ "$3" = "reverse" ]; then
        exit 42
      fi
    EOS

    fakeadb.chmod 0755
    ENV["ADB"] = fakeadb

    # It's expected to fail after adb reverse step because fakeadb exits
    # with code 42
    out = shell_output("#{bin}scrcpy --no-display --record=file.mp4 -p 1337 2>&1", 1)
    assert_match( 42, out)

    log_content = File.read(testpath"fakeadb.log")

    # Check that it used port we've specified
    assert_match(tcp:1337, log_content)

    # Check that it tried to push something from its prefix
    assert_match(push #{prefix}, log_content)
  end
end