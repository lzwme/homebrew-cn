class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "https://gpsd.gitlab.io/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.27.3.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.27.3.tar.xz"
  sha256 "e4a3c978a00242ba68ef50cd7c466a8ab3ecb5fe07fd3f9cf2054619ccad5653"
  license "BSD-2-Clause"
  head "https://gitlab.com/gpsd/gpsd.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c26ce8784557e63069c262612d00a2aefb59e2fe7d354b6079947b0e6941d299"
    sha256 cellar: :any,                 arm64_sequoia: "c689bc54231aa8d1b2215b45b5141e4bc34b5b5877f6eda691d1e1a88c713a20"
    sha256 cellar: :any,                 arm64_sonoma:  "ccfefb5befe37f9de0759a2a32fedb946cc12a04e2e9d3e9b4d77de496a2a017"
    sha256 cellar: :any,                 sonoma:        "fad68bb702fae024c3310b6a2a3ab1b85b11def499afb3b56a8896846e9744fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4681c8bdf5ac15814dc37055e21b8cac2089eeb217c847a50559fb0a3aa4f82c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8323a9faa31fe5e626ab3ff84b830fcffb446552f6f37b98c4e102187d966195"
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