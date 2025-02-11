class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http:eighttails.seesaa.net gives 405 error
  homepage "https:github.comeighttailsPC6001VX"
  url "https:eighttails.up.seesaa.netbinPC6001VX_4.2.11_src.tar.gz"
  sha256 "8ad576192b555d0c21c1317351c52fce7b9ecb02c8ee9bd52ceb5e4b61901b4b"
  license "LGPL-2.1-or-later"
  head "https:github.comeighttailsPC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "9fddc92fb7e6ca19f25562ad71eff9a26b863106ebc03216cf4a72dc253ca77a"
    sha256 cellar: :any,                 arm64_ventura: "f857f85c65c842ad9134cf60192f236148fea7a84c4234528cb9f2e86b9281b8"
    sha256 cellar: :any,                 sonoma:        "5d2462d66e58c7b68ac15d6baccc9e91eb92ff6e9b208fc8eb70bf0e06a46498"
    sha256 cellar: :any,                 ventura:       "2d70e0965f8aa7c2378e27d694be1e7bba03e971856a2309f466df96855b5243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ede1b7b32adbb569385fc75ea1e5ca5c630beaab2a9d578006a192fe3ee299c1"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "sdl2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
  end

  def install
    mkdir "build" do
      system "qmake", "PREFIX=#{prefix}",
                      "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                      "CONFIG+=no_include_pwd",
                      ".."
      system "make"

      if OS.mac?
        prefix.install "PC6001VX.app"
        bin.write_exec_script prefix"PC6001VX.appContentsMacOSPC6001VX"
      else
        bin.install "PC6001VX"
      end
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"

    user_config_dir = testpath".pc6001vx4"
    user_config_dir.mkpath
    pid = spawn bin"PC6001VX"
    sleep 30
    sleep 45 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists user_config_dir"rom", "User config directory should exist"
  ensure
    # the first SIGTERM signal closes a window which spawns another immediately
    # after 5 seconds, send a second SIGTERM signal to ensure the process is fully stopped
    Process.kill("TERM", pid)
    sleep 5
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end