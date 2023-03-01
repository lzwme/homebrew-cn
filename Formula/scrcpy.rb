class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://ghproxy.com/https://github.com/Genymobile/scrcpy/archive/v1.25.tar.gz"
  sha256 "dfecc9dcffd45540bef88a7e346d37bead3665a5c868a5a95c5ec7bfed43ad07"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "2cc4c088a3947f8f5de8117c905dd930bb770ce1f57d3fae6341575a8f7f324e"
    sha256 arm64_monterey: "56a8daf6290556a5d1f6a5e9fa3ed25a60b198e7141e7df58781b1387c35c44e"
    sha256 arm64_big_sur:  "8a8c6f4013eecd32c0a7eef691f087f85e75df6e24768588ea59874ba4cb6686"
    sha256 ventura:        "1c1502eb5267ac6d39c40e1f83ebe51dc797e3e9657dc8e88f39c4c5145ed08b"
    sha256 monterey:       "9612404cadb3c56fb9e7c231b948eff51bcbe2947b0fd310c0bdd693dbbbd488"
    sha256 big_sur:        "4a0e604cccb0fb270944747557056dcc5dc78a1304876b63c6b89dce085b3c5e"
    sha256 x86_64_linux:   "d62deca07d0e14a8ee1126547735142f5766a9acf00383c1c2cdd6ae19017fff"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://ghproxy.com/https://github.com/Genymobile/scrcpy/releases/download/v1.25/scrcpy-server-v1.25"
    sha256 "ce0306c7bbd06ae72f6d06f7ec0ee33774995a65de71e0a83813ecb67aec9bdb"
  end

  def install
    r = resource("prebuilt-server")
    r.fetch
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", *std_meson_args,
                      "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
                      ".."

      system "ninja", "install"
    end
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    fakeadb = (testpath/"fakeadb.sh")

    # When running, scrcpy calls adb five times:
    #  - adb start-server
    #  - adb devices -l
    #  - adb -s SERIAL push ... (to push scrcpy-server.jar)
    #  - adb -s SERIAL reverse ... tcp:PORT ...
    #  - adb -s SERIAL shell ...
    # However, exiting on $3 = shell didn't work properly, so instead
    # fakeadb exits on $3 = reverse

    fakeadb.write <<~EOS
      #!/bin/sh
      echo "$@" >> #{testpath/"fakeadb.log"}

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
    out = shell_output("#{bin}/scrcpy --no-display --record=file.mp4 -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end