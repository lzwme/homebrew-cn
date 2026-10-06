class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://ghfast.top/https://github.com/Genymobile/scrcpy/archive/refs/tags/v5.0.tar.gz"
  sha256 "a431f6ed9e63629938464bbfe92b022d6dddf09d7e1d52758b3fc5b52d4c4b03"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "0fbbcce5c43425e9d6d986dc280cfbbf00d8a054571573061062f7147e699e77"
    sha256 arm64_tahoe:       "e15c53aff881e7d42a6eb941ca0561e36f4f61459ad01241ec3e9358900b2938"
    sha256 arm64_sequoia:     "477a91ee3ff1ed0e2f1f074d5cc31928681ee8f6e278cfa47727e257b38a9f8b"
    sha256 arm64_linux:       "303ec2793ed1dfe3792f740e76850df6f3f04bcbd931a39a0c3f565d558dc527"
    sha256 x86_64_linux:      "e73d14c83073e71158e5874045b6515284a9cf3c9b5a53c8cced9febb8a6d980"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl3"

  on_linux do
    depends_on "libdrm"
  end

  resource "prebuilt-server" do
    url "https://ghfast.top/https://github.com/Genymobile/scrcpy/releases/download/v5.0/scrcpy-server-v5.0", using: :nounzip
    sha256 "26cbc9ad0aced6c2282455bef4fb43462605c1f8758c74b4ab1dbf818c229daa"

    livecheck do
      formula :parent
    end
  end

  allow_network_access! :test

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