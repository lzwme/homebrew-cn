class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://ghproxy.com/https://github.com/Genymobile/scrcpy/archive/refs/tags/v2.3.tar.gz"
  sha256 "70937335be7c8b0be3dcf4ae2b0371e5dbe6cf340bf4ccb341be3d10fc039c36"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "52585e520798ff519b2cd1bc47801f2941d0c400931c6cbc90af744b231c8a8f"
    sha256 arm64_ventura:  "91b9b1534720b0e90205eff30a8da6773ec820f3ac54a73d7e80c8b390819d69"
    sha256 arm64_monterey: "24b2905f21f601e1311d8ec7eb59036c04134c2b0e34d9db895fb96c6a742d70"
    sha256 sonoma:         "0ff83ecae908c44f8dacae8dbf84d6e053b2f5f7a7d1df0f2d78af3a134cfada"
    sha256 ventura:        "eda5fe74a87b5cb4543e5f03bdbd87a4aea609e4f0bd63a08cca1e8f53c5299a"
    sha256 monterey:       "43c493039aaf755e6fd9e15459c7c38815dd4a43b57b88203652d86c29e6449d"
    sha256 x86_64_linux:   "4f9a3cb26cbcb0cce68181a0f1bf38f548bf17c9f0f8bd0b81f5f837b549157a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://ghproxy.com/https://github.com/Genymobile/scrcpy/releases/download/v2.3/scrcpy-server-v2.3"
    sha256 "8daed514d7796fca6987dc973e201bd15ba51d0f7258973dec92d9ded00dbd5f"
  end

  # Fix compilation error:
  #   ../app/src/cli.c:2158:17: error: expected expression
  #                   enum sc_orientation orientation;
  #                   ^
  #
  # Patch accepted upstream, remove on next release
  patch do
    url "https://github.com/Genymobile/scrcpy/commit/4135c411af419f4f86dc9ec9301c88012d616c49.patch?full_index=1"
    sha256 "634d3f936d72848e90579a327c6f61d065f42baf96798113d74fe73fc46000a7"
  end

  def install
    r = resource("prebuilt-server")
    r.fetch
    cp r.cached_download, buildpath/"prebuilt-server.jar"

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
    assert_equal version, resource("prebuilt-server").version, "`prebuilt-server` resource needs updating!"

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