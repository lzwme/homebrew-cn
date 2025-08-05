class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://ghfast.top/https://github.com/badaix/snapcast/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "66a353f29ff232714ab317ca28462137423d6ef9ea5aba08f6d9ca5cc2a7fea7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b8b1b274e6c53bb74eed41110aa05f02a0760caf9cadea882db3a74508d92d74"
    sha256 cellar: :any,                 arm64_sonoma:  "728af4d5f86dd9cd465529530930855c52f3ee41b260afc52044262a5196a464"
    sha256 cellar: :any,                 arm64_ventura: "f8e64aec9d98e66bb8e44e7424bb8efff4bdd259abdb9850ec6c606ec19fc18b"
    sha256 cellar: :any,                 sonoma:        "2949ee2baa98207fd9617614599b1514c6b69c105f55b6845e7b4eefa834bcec"
    sha256 cellar: :any,                 ventura:       "5686f1320051bf5c0720123e2787eb56036df35255308f10e04dff12dfbb4245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1510f0fdebcb1d51e2196d91dedc8ed168e00e19a06c83cc5a07dcadf27a7d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80d886d778608ad4b0ecb1fda310ed171aa8a9c60ba3a2db45fd140346b838cf"
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