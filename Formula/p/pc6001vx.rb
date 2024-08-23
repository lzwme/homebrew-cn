class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http:eighttails.seesaa.net gives 405 error
  homepage "https:github.comeighttailsPC6001VX"
  url "https:eighttails.up.seesaa.netbinPC6001VX_4.2.9_src.tar.gz"
  sha256 "6819cbf3a883a5b613c3b7f29255aa935afdb0c2dcb14c04e644d5b24be117c1"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.comeighttailsPC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0734e27c0498560e32afeaf382ac7a228d691741440a0bbfd633624513ccf229"
    sha256 cellar: :any, arm64_ventura:  "b40cf6a5735daacca9e76539caffbb1cb864f14f74625edbe9f5004361fc9712"
    sha256 cellar: :any, arm64_monterey: "9e71228dceca49f46785e01fce810a5e7302a2d8c54e1c83f0045166d0920cc9"
    sha256 cellar: :any, sonoma:         "57526a351e01058156e0047f2f5189ecec4e388f7276ec6961e0b4bbf40fd525"
    sha256 cellar: :any, ventura:        "70f38d4be3d39e24d7182504c4b4ba6534fd4fd3aba2365f83e9e392e728a789"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
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
    sleep 30 if Hardware::CPU.intel?
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