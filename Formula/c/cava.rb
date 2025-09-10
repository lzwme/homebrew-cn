class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://ghfast.top/https://github.com/karlstav/cava/archive/refs/tags/0.10.5.tar.gz"
  sha256 "6cd8c8f22815bb8b557a98da0511b2038de44f050120cbf152fcc74203d301cb"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6da52ed82e01b879293b40935ce96de7bdc7747067992fa27baaa39cf0709219"
    sha256 cellar: :any, arm64_sonoma:  "0c6201ca1b57e813f5a97bb0cb0743e4d18d8fcc0fde4ec15f52a542da3a0dd9"
    sha256 cellar: :any, arm64_ventura: "4ea49ff4ba6c901e2d5bbbe1d7fc8b5d15e260a3c41325ae42c7951ce1302176"
    sha256 cellar: :any, sonoma:        "a6cfa9ac71ac21a65bfd66576f751b432494cacdef484dbc065407c2c443c525"
    sha256 cellar: :any, ventura:       "efaedb9b361061a2768616c561ee5bec953c1855ef592c41a79b2f49340c64a1"
    sha256               arm64_linux:   "94be873751c51dff2c1e7cbce3668bf5d0732c5fcae90e997ff58fd83ecd6ff1"
    sha256               x86_64_linux:  "27dce28838be3ed6d2bc99a73718874bf959cd4cc971d023f312b5e61f4c26da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "pkgconf"  => :build

  depends_on "fftw"
  depends_on "iniparser"
  depends_on "portaudio"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "ncurses"

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  def install
    # change ncursesw to ncurses
    inreplace "configure.ac", "ncursesw", "ncurses"
    # force autogen.sh to look for and use our glibtoolize
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    ENV.append "CPPFLAGS", "-I#{Formula["iniparser"].opt_include}/iniparser"
    ENV.append "LDFLAGS", "-L#{Formula["iniparser"].opt_lib}"

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    cava_config = (testpath/"cava.conf")
    cava_stdout = (testpath/"cava_stdout.log")

    cava_config.write <<~EOS
      [general]
      bars = 2
      sleep_timer = 1

      [input]
      method = fifo
      source = /dev/zero

      [output]
      method = raw
      data_format = ascii
    EOS

    pid = spawn(bin/"cava", "-p", cava_config, [:out, :err] => cava_stdout.to_s)

    sleep 5

    assert_match "0;0;\n", cava_stdout.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end