class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https:sites.google.comsitegogdownloader"
  url "https:github.comSude-lgogdownloaderreleasesdownloadv3.15lgogdownloader-3.15.tar.gz"
  sha256 "9946558bb30b72cd5ed712e7fc425eef4b2a1fd22b5475d1a998720800cd25f0"
  license "WTFPL"
  revision 2
  head "https:github.comSude-lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f802edd60d60cb14be5eb3d9360a016c37adb50b8b85e0244b9343f0b87a423"
    sha256 cellar: :any,                 arm64_sonoma:  "068b621626acb6d1fe244f5e23563291706f5f3b48fbb51d57f46d6923e93950"
    sha256 cellar: :any,                 arm64_ventura: "2000bba7f6b8a40619ddef69025cf5688a9c9398f63bac497ea81ee8a89d16e8"
    sha256 cellar: :any,                 sonoma:        "fa39dcebf2fc5db392c1466d2bb263a0da065e3c6383dd184141b36734737937"
    sha256 cellar: :any,                 ventura:       "a813c264522bea16bd899a90421647191adfa7e57e6819ab404194531811b9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bae3f52fd3b0ba829ac3e967c87be19d33d25b6920dbf6b2c4de03359e9aa14"
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