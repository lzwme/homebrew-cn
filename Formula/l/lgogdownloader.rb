class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https:sites.google.comsitegogdownloader"
  url "https:github.comSude-lgogdownloaderreleasesdownloadv3.16lgogdownloader-3.16.tar.gz"
  sha256 "24b005bf3caf00ebc8c603251f5689d66098f66dd37bdf399836289064cb0c9f"
  license "WTFPL"
  revision 1
  head "https:github.comSude-lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4096ebf71974d393f141d5bdbad4a72cebdaa94035800b9d37fce1e705682d3"
    sha256 cellar: :any,                 arm64_sonoma:  "1b27967b04562802916c2539532b72f5f272b07f7f44e8b3d7587e8c6bec7cf7"
    sha256 cellar: :any,                 arm64_ventura: "c9a2be10e0e0e8ce86245d600f283c211d1e33233d6c4b7b410f9985d2dd02eb"
    sha256 cellar: :any,                 sonoma:        "b3005345ae6f1981d734fd140724e251aa485b5de08debc879111a2c56ece18d"
    sha256 cellar: :any,                 ventura:       "dda0dc07470e28f83a9d28ce6d71a21f3f25afb6ff4ecb344074c14ae5bf4b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c01e0ac81642ca1077745caf6baefe62356fa3b7404ab8ab03778a7b7e669a5b"
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "rhash"
  depends_on "tidy-html5"
  depends_on "tinyxml2"

  uses_from_macos "curl"

  def install
    args = %W[
      -DJSONCPP_INCLUDE_DIR=#{Formula["jsoncpp"].opt_include}
      -DBoost_INCLUDE_DIR=#{Formula["boost"].opt_include}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    require "pty"

    ENV["XDG_CONFIG_HOME"] = testpath
    reader, writer = PTY.spawn(bin"lgogdownloader", "--list", "--retries", "1")
    writer.write <<~EOS
      test@example.com
      secret
      https:auth.gog.comauth?client_id=xxx
    EOS
    writer.close
    lastline = ""
    begin
      reader.each_line { |line| lastline = line }
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end
    assert_equal "Galaxy: Login failed", lastline.chomp
    reader.close
  end
end