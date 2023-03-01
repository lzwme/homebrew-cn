class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://ghproxy.com/https://github.com/hrkfdn/ncspot/archive/v0.12.0.tar.gz"
  sha256 "9623bc4cf9be4340a7b4de809889a515553da82d3d6b98b13e0646c60c124a44"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3d9c8a4808d2d2da26f423896ad2ab3e0de7293cb9abb83194a90fb84dc1ee89"
    sha256 cellar: :any,                 arm64_monterey: "73ccc7eb333caccbe1681898af604e1a2971f14af34a86f512e601e8f60d1a9f"
    sha256 cellar: :any,                 arm64_big_sur:  "b2c803b0b9cb40f62929b42fe3298b6f984a5c4122d6df758150250847ee317e"
    sha256 cellar: :any,                 ventura:        "34298445ec0ff4ee3c6f5df02a4e630e1982aa78c47c1102fcaba37ecbee5e8c"
    sha256 cellar: :any,                 monterey:       "59e8716b36d9674065376bdb3a49d44fa3965ac2ed37eb4c5a393b1fdf66c1f5"
    sha256 cellar: :any,                 big_sur:        "1cf70a6db828b3409e71366fad4ddcf525ed1a7ea1c808a91335a5db53245810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd178707299119b0cc56f0f7cceb5b3ce8d37fe91a5c76df744692d6737f413d"
  end

  depends_on "python@3.11" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features", "portaudio_backend,cursive/pancurses-backend,share_clipboard",
                               *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match "portaudio", shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    if OS.mac?
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "Please login to Spotify", stdout.read
    end
  end
end