class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https:github.comkarlstavcava"
  url "https:github.comkarlstavcavaarchiverefstags0.10.0.tar.gz"
  sha256 "1e40c93cb476ada538c131cb68ab1b56ce214d75b834508cbe76a57ae1ea153f"
  license "MIT"
  head "https:github.comkarlstavcava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "08b5bb86ede6893122a35fb2472a4b4ab3fb80005bc9c2a97745449c2b7633e4"
    sha256 cellar: :any, arm64_ventura:  "df91bfd8b1dcc5d5e521bede9fa006104b7985dbb8b5ca0cb0a5327c5834b70a"
    sha256 cellar: :any, arm64_monterey: "f37d8d2a65017e67fad3ac2cb57088535fef50d3cae30c168a7c7856dc814dca"
    sha256 cellar: :any, sonoma:         "c3d974e0487f23a5f610be9db4a4052a681cb163aab9dd78d9ca067837604e90"
    sha256 cellar: :any, ventura:        "aa13c8b6f1719538c8d51d009bcca5ec4e20bcf8703fb58f53e43f4b0fb0bc7d"
    sha256 cellar: :any, monterey:       "3c24c072df8b5d4f975287e9494a897d69d0f3c35395b575a79eee97b88c76ac"
    sha256               x86_64_linux:   "05ff4b4cec34f8edafd52c4ca8796bfecc946aa9f2e68e92b39dc3525dd3b821"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "pkg-config"  => :build
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

    system ".autogen.sh"
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    cava_config = (testpath"cava.conf")
    cava_stdout = (testpath"cava_stdout.log")

    cava_config.write <<~EOS
      [general]
      bars = 2
      sleep_timer = 1

      [input]
      method = fifo
      source = devzero

      [output]
      method = raw
      data_format = ascii
    EOS

    pid = spawn(bin"cava", "-p", cava_config, [:out, :err] => cava_stdout.to_s)
    sleep 2
    Process.kill "KILL", pid
    assert_match "0;0;\n", cava_stdout.read
  end
end