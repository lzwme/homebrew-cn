class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https:sites.google.comsitegogdownloader"
  url "https:github.comSude-lgogdownloaderreleasesdownloadv3.12lgogdownloader-3.12.tar.gz"
  sha256 "bf3a16c1b2ff09152f9ac52ea9b52dfc0afae799ed1b370913149cec87154529"
  license "WTFPL"
  revision 1
  head "https:github.comSude-lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7b04838f77fc60c707c35aff6cea7b4ba354675b9e5b2c144b33beef383295eb"
    sha256 cellar: :any,                 arm64_ventura:  "84a3914e2d8e7b7d6a1553855c663e1d0a3ba8bfb9dffad419742f97ce5d3a79"
    sha256 cellar: :any,                 arm64_monterey: "9f04cdaef27f2e84584481f48d72d550e7c21dec17ef369b3b0cbf66ee9d25a5"
    sha256 cellar: :any,                 sonoma:         "fd77cdaa513f8bdc9c09bd00831d08c25449458e712a3a5d47de2719e3a4fd8f"
    sha256 cellar: :any,                 ventura:        "6e00a43a93088d222da74664e110b5b2bc39cc3d2478db0a670303d532d03e52"
    sha256 cellar: :any,                 monterey:       "484326ad4707a35e9a658438b95c8969b70d696abea33d592884b13bbdba14d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "697fce9fc55cd5a0e20ad104829fd40757036b263417136c0facf217712993cb"
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