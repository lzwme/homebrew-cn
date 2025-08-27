class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.13_src.tar.gz"
  sha256 "2bfb323ce600dd886d9370fd0d53678df12fbcdf6ddb4510e7dfd0816fa22616"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "2084cf7f35f05b57a6f287720ec59d862a780d322c238f681aebeba13bba2405"
    sha256 cellar: :any,                 arm64_ventura: "c359ef38a9b63f8927e0458ed7b16b4e7d0005f56b6e8f8c95d4c1412b3efa73"
    sha256 cellar: :any,                 sonoma:        "fb47f05671a8c2f577f654cdae937e26e28f55c9ffb8be43a333da2d9944c399"
    sha256 cellar: :any,                 ventura:       "53908f1d29ff8e56ca8e2934ba30b3fdd5921cee4527164ee321c1822ffa6764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bba6da83c7b062508d8f71869c158f6fdb4843bb47a5463910dfe895aa82039"
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
        bin.write_exec_script prefix/"PC6001VX.app/Contents/MacOS/PC6001VX"
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

    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = spawn bin/"PC6001VX"
    sleep 30
    sleep 45 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists user_config_dir/"rom", "User config directory should exist"
  ensure
    # the first SIGTERM signal closes a window which spawns another immediately
    # after 5 seconds, send a second SIGTERM signal to ensure the process is fully stopped
    Process.kill("TERM", pid)
    sleep 5
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end