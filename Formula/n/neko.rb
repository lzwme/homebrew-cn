class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https:nekovm.org"
  url "https:github.comHaxeFoundationnekoarchiverefstagsv2-4-0.tar.gz"
  version "2.4.0"
  sha256 "232d030ce27ce648f3b3dd11e39dca0a609347336b439a4a59e9a5c0a465ce15"
  license "MIT"
  head "https:github.comHaxeFoundationneko.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "f328cd57b25a6f02f44b9124020c60e0729b8ab66293263290569403dde76ad9"
    sha256 arm64_ventura:  "1b43732229a9c256a5ef317d4d46887f57073e1166f8dcaf0bd42043b88e5c3b"
    sha256 arm64_monterey: "b3090d3aa25403f4084b154e5920b8f2c1434c2a1ec11ba48a114452f46e4a2f"
    sha256 sonoma:         "ca35339d3a40d4f817d4b04a2bcd5b0cdafa623aae869c554fb016a8cedae682"
    sha256 ventura:        "0b8d1d088a6f5e251f1cda6642614224f63e31873328c7f85d69721c653d65ec"
    sha256 monterey:       "a18d3cf349b7a01404af808e4e72e7f44be5a2a76a829ecc7a88f15a0c0ae23b"
    sha256 x86_64_linux:   "4c068527390aaa0c95262fa54367ad354b5ec2bf0bd2658d1b0fe312ea87a8ac"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "mysql-client"
  depends_on "pcre2"
  depends_on "zlib" # due to `mysql-client`

  uses_from_macos "sqlite"

  on_linux do
    depends_on "apr"
    depends_on "apr-util"
    depends_on "gtk+3" # On mac, neko uses carbon. On Linux it uses gtk3
    depends_on "httpd"
  end

  def install
    args = %w[
      -DRELOCATABLE=OFF
      -DRUN_LDCONFIG=OFF
    ]
    if OS.linux?
      args << "-DAPR_LIBRARY=#{Formula["apr"].opt_lib}"
      args << "-DAPR_INCLUDE_DIR=#{Formula["apr"].opt_include}apr-1"
      args << "-DAPRUTIL_LIBRARY=#{Formula["apr-util"].opt_lib}"
      args << "-DAPRUTIL_INCLUDE_DIR=#{Formula["apr-util"].opt_include}apr-1"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "usrlocal"
      s << <<~EOS
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}libneko"
      EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}libneko"
    system "#{bin}neko", "-version"
    (testpath"hello.neko").write '$print("Hello world!\n");'
    system "#{bin}nekoc", "hello.neko"
    assert_equal "Hello world!\n", shell_output("#{bin}neko hello")
  end
end