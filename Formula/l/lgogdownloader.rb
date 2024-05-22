class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https:sites.google.comsitegogdownloader"
  url "https:github.comSude-lgogdownloaderreleasesdownloadv3.13lgogdownloader-3.13.tar.gz"
  sha256 "e1bd9abd5955ad6a6d083674021cd9421d03473ce90d6e6a1a497f71c05d1fd0"
  license "WTFPL"
  head "https:github.comSude-lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c39b51c0929ab9e65b5c471fc6f41f8cbe450ed02fe39dd93260504aeda9e539"
    sha256 cellar: :any,                 arm64_ventura:  "fb8480c15c6345b33694d30f9ad7568adde94cd420607d6daf521068093896d4"
    sha256 cellar: :any,                 arm64_monterey: "76fc11825a70630471c8a08bce9cc7b1ec57736383df41da4a20d5b9a8051696"
    sha256 cellar: :any,                 sonoma:         "483cd8e03fabb72d719fd8e6b9fdb2f132691351bbf5b3548c978f1037d9e295"
    sha256 cellar: :any,                 ventura:        "5af4fa67f195a665fdbb0155c3f7b64c3fe565abd35e78ff77ead03bacabbd37"
    sha256 cellar: :any,                 monterey:       "9432b3766cea74573f73e38103058c3bb0a501434dc64cfa94a32297b9b978d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a635ac3dd9da4f2169a99ce011e157b44d6c4d9eaa1ffd88d43246cd113f6a7a"
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
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