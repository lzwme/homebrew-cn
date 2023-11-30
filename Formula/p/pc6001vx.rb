class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.4_src.tar.gz"
  sha256 "0c9e565e6181e671c1f499808d9ca73b50a9b49e4b0633198f294b0d1076cf08"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8c2349078303be614f81f90886be8475a5dad78b3d6e7943147795b2bb912da3"
    sha256 cellar: :any, arm64_ventura:  "9668de632c9554a08006dec3d5d13f8ff89a1ce7b9dc6cc49c2d01c2e454ab03"
    sha256 cellar: :any, arm64_monterey: "90ddde2dee645f7409e9498a66eeca770f7ffa6ce29232cc71a19d933666b640"
    sha256 cellar: :any, sonoma:         "b6be52fbf0469a172ae8787c5c9738fc7e6717ae89e32e5d5fa32b3c09662572"
    sha256 cellar: :any, ventura:        "9964359aade260f818334799e0f7f45a9e11ea4448d80eb09e3d51826d99f698"
    sha256 cellar: :any, monterey:       "2a678d7169cc25304bb134f353bebeb344b63423ea40be7d116abb4be650861d"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    mkdir "build" do
      system "qmake", "PREFIX=#{prefix}",
                                 "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                                 "CONFIG+=no_include_pwd",
                                 ".."
      system "make"

      prefix.install "PC6001VX.app"
      bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
    end
  end

  test do
    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = fork do
      exec bin/"PC6001VX"
    end
    sleep 20
    assert_predicate user_config_dir/"rom",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end