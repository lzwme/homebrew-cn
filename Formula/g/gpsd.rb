class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.27.2.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.27.2.tar.xz"
  sha256 "af7071da29f89b27d77635a42b8ec85278f52ff6489b97ec5f79b58b33073f5f"
  license "BSD-2-Clause"
  head "https://gitlab.com/gpsd/gpsd.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b48d4791f0d1c6d2c582b73c4ec5983b1f7f699531a983f8edbc0c66f4277ace"
    sha256 cellar: :any,                 arm64_sequoia: "47bebe7d2e57759e9e7059f9309c23f85f8e873b69007d9248a05485b3b08e13"
    sha256 cellar: :any,                 arm64_sonoma:  "eebe98fc418cbd2fdcee45dc6c82cebbcc2d1c80646c4396210532a7cc50de72"
    sha256 cellar: :any,                 sonoma:        "bd0b12fb1a68ac3bff7428153d82246e80ba205f3e4bc3a72c776c31ca3ea255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c521d8d528323c1da4c9278043b12b451bb225beb32c137e992b70275adf1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "573a3b93a0fb0ddecd738ccfa9c6f59099e7810271228152a915e9629ffe90df"
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