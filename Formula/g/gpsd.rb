class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.27.1.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.27.1.tar.xz"
  sha256 "0d1fb9d01612a3c36a85d1cf252a684831a636a94c3a8d85999062e2a856b40a"
  license "BSD-2-Clause"
  head "https://gitlab.com/gpsd/gpsd.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2e272a9b4fe497f4e9f3c9fc0d936804e9a62c3c1f5aa99e2fc8027a012d00f"
    sha256 cellar: :any,                 arm64_sequoia: "0aa3bb1363d93f597cdb0815ab76199dcf885f2d9e5118aafcafe9e280d654d6"
    sha256 cellar: :any,                 arm64_sonoma:  "0c8446f0c18a1c6e1b43d507eb2d7c5dacadb8bf5293e0598b8917d03b852595"
    sha256 cellar: :any,                 sonoma:        "91dd545a375aaa045b350712e39e0e91ce782091ae0604d38381d09b9316cd02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f2ad4911ac1e2bc6ea0598c09dc9557117f921653c1870bd5d81573daf3957d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bac38fe3812df5b7465c89e5cad092c0f6adf21b331e5adb6bcfad2884402a"
  end

  depends_on "asciidoctor" => :build
  depends_on "scons" => :build

  uses_from_macos "ncurses"

  def install
    if OS.linux?
      ncurses = Formula["ncurses"]

      ENV.append "CFLAGS", "-I#{ncurses.opt_include}"
      ENV.append "LDFLAGS", "-L#{ncurses.opt_lib} -Wl,-rpath,#{ncurses.opt_lib}"
    end

    system "scons", "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    system "scons", "install"
  end

  def caveats
    <<~EOS
      gpsd does not automatically detect GPS device addresses. Once started, you
      need to force it to connect to your GPS:

        GPSD_SOCKET="#{var}/gpsd.sock" #{sbin}/gpsdctl add /dev/tty.usbserial-XYZ
    EOS
  end

  service do
    run [opt_sbin/"gpsd", "-N", "-F", var/"gpsd.sock"]
    keep_alive true
    error_log_path var/"log/gpsd.log"
    log_path var/"log/gpsd.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/gpsd -V")
  end
end