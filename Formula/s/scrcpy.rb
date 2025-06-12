class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https:github.comGenymobilescrcpy"
  url "https:github.comGenymobilescrcpyarchiverefstagsv3.3.tar.gz"
  sha256 "6636f97f3a5446e3a1c845545108cf692bbd9cdc02cacfda099a2789ca7f6d56"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "319a8337530bab6304ba3832d7567a440ab5eaf0c64febf7fe021fb92c73b5af"
    sha256 arm64_sonoma:  "d5b4313e9a3283df2c3fa82914989d02024061aa023b4d39472134a75165a8b9"
    sha256 arm64_ventura: "859e4339042a0cbe616138afce3e00ca3bd5c754e9c7837b02bf2967bb26d38a"
    sha256 sonoma:        "81bb76ea84532e4bb3f2bdbb8b52c94655fa9db0dcd1e00f5c332e19a0293b3e"
    sha256 ventura:       "294fbb3474543067fb0bc2694f9199e8df76d6881de7d8c312c043cd5951ee15"
    sha256 arm64_linux:   "db78c3a7f231356db8a755fa2da69e3c6666675c3c6596de7844e057ebf3894a"
    sha256 x86_64_linux:  "b645c3038ce3ac22352f51b6addd8a3557162eb09617ca79f87b76d4eba783d2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https:github.comGenymobilescrcpyreleasesdownloadv3.3scrcpy-server-v3.3"
    sha256 "351cb2edc7e4c2c75f09a7933fdabcf137be52e2602df154f24ec02db46e9e51"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "prebuilt-server resource needs to be updated" if version != resource("prebuilt-server").version

    buildpath.install resource("prebuilt-server")
    cp "scrcpy-server-v#{version}", "prebuilt-server.jar"

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
    fakeadb = (testpath"fakeadb.sh")

    # When running, scrcpy calls adb five times:
    #  - adb start-server
    #  - adb devices -l
    #  - adb -s SERIAL push ... (to push scrcpy-server.jar)
    #  - adb -s SERIAL reverse ... tcp:PORT ...
    #  - adb -s SERIAL shell ...
    # However, exiting on $3 = shell didn't work properly, so instead
    # fakeadb exits on $3 = reverse

    fakeadb.write <<~SH
      #!binsh
      echo "$@" >> #{testpath"fakeadb.log"}

      if [ "$1" = "devices" ]; then
        echo "List of devices attached"
        echo "emulator-1337          device product:sdk_gphone64_x86_64 model:sdk_gphone64_x86_64 device:emulator64_x86_64_arm64 transport_id:1"
      fi

      if [ "$3" = "reverse" ]; then
        exit 42
      fi
    SH

    fakeadb.chmod 0755
    ENV["ADB"] = fakeadb

    # It's expected to fail after adb reverse step because fakeadb exits
    # with code 42
    out = shell_output("#{bin}scrcpy --no-window --record=file.mp4 -p 1337 2>&1", 1)
    assert_match( 42, out)

    log_content = File.read(testpath"fakeadb.log")

    # Check that it used port we've specified
    assert_match(tcp:1337, log_content)

    # Check that it tried to push something from its prefix
    assert_match(push #{prefix}, log_content)
  end
end