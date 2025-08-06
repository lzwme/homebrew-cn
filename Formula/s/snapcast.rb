class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://ghfast.top/https://github.com/badaix/snapcast/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "881173321f5fc929319d31b5063d91a25187e61e984cdb85e57266ea5e2b3f7f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e142926f29f749357847e4b9a825eecc5efafb539fe36920afe717c8feb9225d"
    sha256 cellar: :any,                 arm64_sonoma:  "fd336c2bc21b15767f151d984135d3c447ccf3ebe4ba9afb58cfb518c09c0baa"
    sha256 cellar: :any,                 arm64_ventura: "01932c1c8c3eb3846f7d662f8de593961f2ce5069fb72e9867dea18ed5fa7812"
    sha256 cellar: :any,                 sonoma:        "a5841ef92042b82d8c6a44d7a9b8b7d9449ccc0c9a2cdc0390b5ef5df0491264"
    sha256 cellar: :any,                 ventura:       "2e706e6d2a72e0facb33836ae796d73fbcda8daf0143439cae7ac642d8815c4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac6b6d41cd4c9f87f4d820cab697f74a995d2b9846bd46363b3777269c54bc18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f33eb06e5914f1e5498e8f7e20b09fc405407ac09423a3d3662b0f7b26c52358"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "openssl@3"
  depends_on "opus"

  uses_from_macos "expat"

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
    depends_on "pulseaudio"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # FIXME: if permissions aren't changed, the install fails with:
    # Error: Failed to read Mach-O binary: share/snapserver/plug-ins/meta_mpd.py
    chmod 0555, share/"snapserver/plug-ins/meta_mpd.py"
  end

  test do
    server_pid = spawn bin/"snapserver"
    sleep 2

    begin
      output_log = testpath/"output.log"
      client_pid = spawn bin/"snapclient", [:out, :err] => output_log.to_s
      sleep 10
      if OS.mac?
        assert_match version.to_s, output_log.read
      else
        # Needs Avahi (which also needs D-Bus system bus) which requires root
        assert_match "BrowseAvahi - Failed to create client", output_log.read
      end
    ensure
      Process.kill("SIGTERM", client_pid)
    end
  ensure
    Process.kill("SIGTERM", server_pid)
  end
end