class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https:sites.google.comsitegogdownloader"
  url "https:github.comSude-lgogdownloaderreleasesdownloadv3.12lgogdownloader-3.12.tar.gz"
  sha256 "bf3a16c1b2ff09152f9ac52ea9b52dfc0afae799ed1b370913149cec87154529"
  license "WTFPL"
  head "https:github.comSude-lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97023f97d4d5ed35f0539c7e744d54558befe7e7dfeb37e5a2161d6e77a99e9e"
    sha256 cellar: :any,                 arm64_ventura:  "1e7dbdea45ebc15b3beeee679e36b011fcb783844168805f12c25f0ef6ecfc82"
    sha256 cellar: :any,                 arm64_monterey: "992dca40e5cd78f3bd5b1305ee3cea3fcceae07b41f2a31636bba22051af6262"
    sha256 cellar: :any,                 sonoma:         "5a5b6d8ba49defb1df309931cd8caf3e3564f709965beb4e62f24dd9bb0f877d"
    sha256 cellar: :any,                 ventura:        "d97855706a9f0c9742630f645b091e561c8aa37305932cb1f95d49a73ae73184"
    sha256 cellar: :any,                 monterey:       "3a0bee78906b6c6d6896290d4fc7c92f355b97bb22337a583ca81c525ee7ce08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1199cade4bb886e13e8f753f27ad2300621fc3eca162f35c7701c195f120656c"
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