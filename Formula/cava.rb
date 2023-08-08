class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://ghproxy.com/https://github.com/karlstav/cava/archive/0.9.0.tar.gz"
  sha256 "3e79367169791fb11236dce6da7b38f46cdd859304710391785c4df7f364fd23"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf60eccdd484b114b3a2d894ea5d810ec2991b6c24622a66be88635d61de0f87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b0c12c6369b178f26a850d12a58b76703e99059105381c471faabd58886dcd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33b3a06b86c4081964770bb04ec6222eab520e140eae67be76af43af208f3aa3"
    sha256 cellar: :any_skip_relocation, ventura:        "d8f2bb30f5daf77c94b5cd2faf9a0d55db771cd8b18f90278a331598f2fb2e33"
    sha256 cellar: :any_skip_relocation, monterey:       "baa0fbb5557eb9acec6857b99be5cc783dc41ae1f283384b6439f148597d8a56"
    sha256 cellar: :any_skip_relocation, big_sur:        "09b6ab175da0cde893a93c908235cf2c5622276d3d3f95f3a46b0e8148ff309e"
    sha256                               x86_64_linux:   "b09c1ed717c25cab60a36b3846d8ac7cdafe09e61be82cef1af0efd84d671d27"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "fftw"
  depends_on "iniparser"
  depends_on "portaudio"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "ncurses"

  def install
    # change ncursesw to ncurses
    inreplace "configure.ac", "ncursesw", "ncurses"
    # force autogen.sh to look for and use our glibtoolize
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
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
    sleep 2
    Process.kill "KILL", pid
    assert_match "0;0;\n", cava_stdout.read
  end
end