class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https:github.combadaixsnapcast"
  url "https:github.combadaixsnapcastarchiverefstagsv0.31.0.tar.gz"
  sha256 "d38d576f85bfa936412413b6860875ba3b462a8e67405f3984a0485778f2fdac"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia: "503bcd02e9c1cee66a0fe1c31b4fb92c456e0403dbeff251ab37a89d097800ba"
    sha256 cellar: :any, arm64_sonoma:  "5148be65fd513313ab9eae89eada1ab878e311c5bf7bae260adc8d9742005213"
    sha256 cellar: :any, arm64_ventura: "0dbfc1421b25651a69006ac4f2dc5995c79ad832f582b57877b53deed618b47e"
    sha256 cellar: :any, sonoma:        "e7a695a5486603ca20361ee1ea25680f77cbfefe31b073b2f881c1f4dd7e7302"
    sha256 cellar: :any, ventura:       "7c12245e729a102ec2b284ce3cc5ff11532269effd442175acc8890c440a1b7f"
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
    # Error: Failed to read Mach-O binary: sharesnapserverplug-insmeta_mpd.py
    chmod 0555, share"snapserverplug-insmeta_mpd.py"
  end

  test do
    server_pid = spawn bin"snapserver"
    sleep 2

    begin
      output_log = testpath"output.log"
      client_pid = spawn bin"snapclient", [:out, :err] => output_log.to_s
      sleep 10
      assert_match("Connected to", output_log.read)
    ensure
      Process.kill("SIGTERM", client_pid)
    end
  ensure
    Process.kill("SIGTERM", server_pid)
  end
end