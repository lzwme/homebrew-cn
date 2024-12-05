class Screenpipe < Formula
  desc "Library to build personalized AI powered by what you've seen, said, or heard"
  homepage "https:github.commediar-aiscreenpipe"
  url "https:github.commediar-aiscreenpipearchiverefstagsv0.2.8.tar.gz"
  sha256 "1166b309204fd7c6f9306ee4da57d918dfdc8c17348510818f872024eb80b700"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "314d86014e668eab13dd7372c0a499d4107e5234507226da78f159df684c21a2"
    sha256 cellar: :any,                 arm64_sonoma:  "27d0088b1ac4fa1f15aa9d1dc702b93aa5aafe39db1e5984ed4ad87eca39cf4d"
    sha256 cellar: :any,                 sonoma:        "2eb870bfe012e75dc88033d1be244cc15b5ba236a81b070c824df786ac9020fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda86006c89f439687538e83c7ecd7785000e2f389374935cda3488649d5786e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on macos: :sonoma

  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@3"
    depends_on "tesseract"
    depends_on "xz"
  end

  def install
    features = ["--features", "metal,pipes"] if OS.mac? && Hardware::CPU.arm?
    system "cargo", "install", *features, *std_cargo_args(path: "screenpipe-server")
    lib.install "screenpipe-visionliblibscreenpipe_#{Hardware::CPU.arch}.dylib" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}screenpipe -V")

    log_file = testpath".screenpipescreenpipe.#{time.strftime("%Y-%m-%d")}.log"
    pid = spawn bin"screenpipe", "--disable-vision", "--disable-audio", "--disable-telemetry"
    sleep 200

    assert_path_exists log_file
    assert_match(INFO.*screenpipe, File.read(log_file))
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end