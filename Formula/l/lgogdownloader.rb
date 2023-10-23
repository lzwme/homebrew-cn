class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://ghproxy.com/https://github.com/Sude-/lgogdownloader/releases/download/v3.11/lgogdownloader-3.11.tar.gz"
  sha256 "d8d015cce6e002876305517367dc006c332e4d492263173b58bfe5a94b057b09"
  license "WTFPL"
  revision 3
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9a814578f4633c887af74d794371311256ec1af78c1673d4c73569059a017ae"
    sha256 cellar: :any,                 arm64_ventura:  "f4146e80d0cfe394b7b141029ae75f95ccbe50ddd924097ca0faf0b5b2b9ceb2"
    sha256 cellar: :any,                 arm64_monterey: "4bd6fa1fb5527eb8eb5a7d48a61641f33f94d3489d5669b55c82c5e621cedd44"
    sha256 cellar: :any,                 sonoma:         "7d470133cdd8be28a3c73c762fbcf444a412602f0f2d32ec3187e4995c774699"
    sha256 cellar: :any,                 ventura:        "9472a37f1e07d124b97260d30f92ae4788602918e72793fd32d63ef7b57bfedd"
    sha256 cellar: :any,                 monterey:       "9b46782875afd73e5c80a42df7ec82a161a4784b476092a3fd1f929057593343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac9f56cb52313da4298b69f83b14632bde16a3db531a7be6d5f2ecf39fdcb55e"
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "rhash"
  depends_on "tinyxml2"

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DJSONCPP_INCLUDE_DIR=#{Formula["jsoncpp"].opt_include}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    require "pty"

    ENV["XDG_CONFIG_HOME"] = testpath
    reader, writer = PTY.spawn(bin/"lgogdownloader", "--list", "--retries", "1")
    writer.write <<~EOS
      test@example.com
      secret
      https://auth.gog.com/auth?client_id=xxx
    EOS
    writer.close
    lastline = ""
    begin
      reader.each_line { |line| lastline = line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_equal "Galaxy: Login failed", lastline.chomp
    reader.close
  end
end