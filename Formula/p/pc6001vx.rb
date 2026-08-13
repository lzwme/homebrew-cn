class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.3.0_src.tar.gz"
  sha256 "a5536f7bd4931b2efcbdcd85707a9c6fa82a6b169773e6d13d74cea8107ee9cc"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ace35aa1b533a55be8d56aa1fabb6e6b2b7f246364f860fda3cb44b397da9f32"
    sha256 cellar: :any, arm64_sequoia: "b5459816667e6c4fe3aae5ee4e02353c54578e4661fc7f8ca70dade61a95157a"
    sha256 cellar: :any, arm64_sonoma:  "3cd052ca2e577a484cd7c3ea0da5bf809be89629c6dfd698126cf3fafd520b5d"
    sha256 cellar: :any, sonoma:        "d3849ca493e07b6531fa4ced73269040855583108e3ff6890271bb6d1c59a55e"
    sha256 cellar: :any, arm64_linux:   "e15149501b274a4382cf21ff5361282320c5c53710dc6f94c52bd319657365a9"
    sha256 cellar: :any, x86_64_linux:  "b45bbd5c4c6ac348440551061c1fc71fb243d04b852b8f6d0e9c0a90ebe28598"
  end

  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "ffmpeg"
  depends_on "qtbase"
  depends_on "qtmultimedia"
  depends_on "sdl2-compat"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
  end

  # Fix builds with FFmpeg 9.
  patch do
    url "https://github.com/eighttails/PC6001VX/commit/5c7079d05cd67b312d324ad09f1e371765b699e4.patch?full_index=1"
    sha256 "cb50d8227ea39602f280b817ddab99aa093a49840f1101713e4e3a3e29e7e6c7"
    type :unofficial
    resolves "https://github.com/eighttails/PC6001VX/pull/29"
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