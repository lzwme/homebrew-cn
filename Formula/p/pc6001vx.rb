class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http:eighttails.seesaa.net gives 405 error
  homepage "https:github.comeighttailsPC6001VX"
  url "https:eighttails.up.seesaa.netbinPC6001VX_4.2.8_src.tar.gz"
  sha256 "18d33c364f8d28c06de9df67c5fa46fe4c14dacbe5f56d2c64af8403e64d64c0"
  license "LGPL-2.1-or-later"
  head "https:github.comeighttailsPC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6b5e394c0c5e4cc3ff91ed130256e6bcbf42fc95e982ba074dcf7fcb38e56ce0"
    sha256 cellar: :any, arm64_ventura:  "8127057088cbe8fbb33525ab5fbaa73fef600ed551bc5aa2983b066bb6e3ec58"
    sha256 cellar: :any, arm64_monterey: "8f4dd14bf5027483bd5ffdd610375fbd0bd31490b69cf5fc70b5cb34a8e34b0b"
    sha256 cellar: :any, sonoma:         "bb40a0aad2d32b91819cd7b240b6b514265490f5965b60a7e18cf6766265ee94"
    sha256 cellar: :any, ventura:        "835bd689bb35e2d7e63c17f4e514044cb5185684a3c459c1748faf2e225499e8"
    sha256 cellar: :any, monterey:       "9ba8b6b9087109613b97bd799b969838abaf1de03280a9268c7f7833df058048"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@6"
  depends_on "qt"
  depends_on "sdl2"

  on_macos do
    depends_on "gettext"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    mkdir "build" do
      system "qmake", "PREFIX=#{prefix}",
                                 "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                                 "CONFIG+=no_include_pwd",
                                 ".."
      system "make"

      prefix.install "PC6001VX.app"
      bin.write_exec_script "#{prefix}PC6001VX.appContentsMacOSPC6001VX"
    end
  end

  test do
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"
    user_config_dir = testpath".pc6001vx4"
    user_config_dir.mkpath
    pid = fork do
      exec bin"PC6001VX"
    end
    sleep 30
    assert_predicate user_config_dir"rom",
                     :exist?, "User config directory should exist"
  ensure
    # the first SIGTERM signal closes a window which spawns another immediately
    # after 5 seconds, send a second SIGTERM signal to ensure the process is fully stopped
    Process.kill("TERM", pid)
    sleep 5
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end