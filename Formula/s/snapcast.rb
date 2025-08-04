class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://ghfast.top/https://github.com/badaix/snapcast/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "57b358ed0b5bcffc287d4ec72249727d522a46b84f4766e83f0ec6e8e312b5b4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f5caa514a957d68041927660e14c1e0672ec3172300732abd8255894d1e72c2f"
    sha256 cellar: :any,                 arm64_sonoma:  "f585413623b8487c4bcc4b3419aba3afe98c3974c0b8462983cce576732be56a"
    sha256 cellar: :any,                 arm64_ventura: "ed4a03214943903364f76cc1bb63c87464fe13ffd36342a77e69b2e7762130ba"
    sha256 cellar: :any,                 sonoma:        "421ba014f996ccc0136ada7347110ff0e6562f83afe41af81b9fc9a4b4f4948f"
    sha256 cellar: :any,                 ventura:       "a137ff7401260cc8156967738488d315b9017ef3723df94840d7da19ce22f4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0a644b1f12dfb7c18b73841845f03b36514717bb28c5d50b1bc246700a7c037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ccaf252e5aaa2defe954af92b8138799bc16d30c0321e5912a1759681821de"
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