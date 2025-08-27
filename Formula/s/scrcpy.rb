class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://ghfast.top/https://github.com/Genymobile/scrcpy/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "9999d2ff3605e1c5d1efb0b737ed6e240a93a928091ab356ba07199c92f52ace"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "c94d1faf84bd3369be7a713d346f9fe7b2008ccf021772afb4517af3aca711cc"
    sha256 arm64_sonoma:  "9f0d9ba5dcaff7fdd8159cdc4c13387d0f8f45071f4e4685504280f6f8a9ec65"
    sha256 arm64_ventura: "6577dbb4dfd59e6bd87075b023891aa475ced1f8c7385e0babae45258b873c83"
    sha256 sonoma:        "1809a37b0334e33961d38e6d8b3c9bb29f5b4f60995d7a8d80baeae7b7fff42d"
    sha256 ventura:       "ef457c676d83e2aca3eb4f8a7413d6070014b50bb0aeebc09de5220f8769f0e6"
    sha256 arm64_linux:   "17f9ef380a008d7e0a66a03b07b68ed4a3db621e89ead280af56d9d0302ffded"
    sha256 x86_64_linux:  "b1efbb86e405f21ebf8b34b511f34de076da3340ebbcb24f02ed366df4359cc6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://ghfast.top/https://github.com/Genymobile/scrcpy/releases/download/v3.3.1/scrcpy-server-v3.3.1", using: :nounzip
    sha256 "a0f70b20aa4998fbf658c94118cd6c8dab6abbb0647a3bdab344d70bc1ebcbb8"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "prebuilt-server resource needs to be updated" if version != resource("prebuilt-server").version

    buildpath.install resource("prebuilt-server")
    cp "scrcpy-server-v#{version}", "prebuilt-server.jar"

    system "meson", "setup", "build", "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
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
    fakeadb = (testpath/"fakeadb.sh")

    # When running, scrcpy calls adb five times:
    #  - adb start-server
    #  - adb devices -l
    #  - adb -s SERIAL push ... (to push scrcpy-server.jar)
    #  - adb -s SERIAL reverse ... tcp:PORT ...
    #  - adb -s SERIAL shell ...
    # However, exiting on $3 = shell didn't work properly, so instead
    # fakeadb exits on $3 = reverse

    fakeadb.write <<~SH
      #!/bin/sh
      echo "$@" >> #{testpath/"fakeadb.log"}

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
    out = shell_output("#{bin}/scrcpy --no-window --record=file.mp4 -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end