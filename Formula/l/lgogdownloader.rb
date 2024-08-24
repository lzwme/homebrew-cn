class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https:sites.google.comsitegogdownloader"
  url "https:github.comSude-lgogdownloaderreleasesdownloadv3.15lgogdownloader-3.15.tar.gz"
  sha256 "9946558bb30b72cd5ed712e7fc425eef4b2a1fd22b5475d1a998720800cd25f0"
  license "WTFPL"
  head "https:github.comSude-lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b26eb399d79a483a3ad61657eebdeac5caebcb444c437e21de09a7116ea4b7f2"
    sha256 cellar: :any,                 arm64_ventura:  "078b353999b81c7dcce69955bb955023a4b5b9ab4aee6ff6448606c34cf11d7b"
    sha256 cellar: :any,                 arm64_monterey: "1e895815c472df5d004da48ae5eee507808af9158502d76b786f992f04c867e6"
    sha256 cellar: :any,                 sonoma:         "94f67390491c4587968a09551a12292fffe2ae4f5b436541b09b4731af716486"
    sha256 cellar: :any,                 ventura:        "381cdee93af3b4c8df26272eaf4f1177f75cc57f0651b930a81c7082c6bdbb58"
    sha256 cellar: :any,                 monterey:       "318c2f7455ab405025479ba704ac33a54869551210eff2443d218836a5fc23c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e86b00e2db846abc67a68d99e04b029fb4ec8018f934f7bd1321fbcc5425e9e4"
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