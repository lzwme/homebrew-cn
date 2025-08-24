class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://ghfast.top/https://github.com/tsduck/tsduck/archive/refs/tags/v3.42-4421.tar.gz"
  sha256 "4e8549967b25cbdc247c27297ef8bfa84a27f291553849fd721680c675822ec5"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4095f60493497b8ff63e6a07a798f237f6ecf0c878d010bb9ff312cbd88d57ed"
    sha256 cellar: :any,                 arm64_sonoma:  "8f2ede174499ba252df84ecb351c497c0bb95e0b2f5f8497f4a17972a2a921fd"
    sha256 cellar: :any,                 arm64_ventura: "3f4e611e71bd9e8915a81bfea6f18afd82663c61e14f5adf1e0d7ee08465192c"
    sha256 cellar: :any,                 sonoma:        "4726f0d7c067ec1c179fa841e5a354dedae677e490f5e18f3d0f660a89f12d0c"
    sha256 cellar: :any,                 ventura:       "8c335a1676e4de4e2ef1a0097c952b5d416401adf3f28ab1a8130eb4c7ae5c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a1afbb06ef1ba369a6f9ac5ae75240dd67eada89c95821a0d2a6040f62e7f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f3b852a4c68b752e3402f0551b2af986627bcfb66e44bc1f796d7e7c3695fd"
  end

  depends_on "asciidoctor" => :build
  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "qpdf" => :build
  depends_on "librist"
  depends_on "libvatek"
  depends_on "openssl@3"
  depends_on "srt"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "pcsc-lite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "bash" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1599
    depends_on "make" => :build
  end

  # Needs clang 16
  fails_with :clang do
    build 1599
    cause "Requires full C++20 support"
  end

  def install
    if OS.linux?
      ENV["LINUXBREW"] = "true"
      ENV["VATEK_CFLAGS"] = "-I#{Formula["libvatek"].opt_include}/vatek"
    end
    system "gmake", "NOGITHUB=1", "NOTEST=1"
    ENV.deparallelize
    system "gmake", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}"
  end

  test do
    assert_match "TSDuck - The MPEG Transport Stream Toolkit", shell_output("#{bin}/tsp --version 2>&1")
    input = shell_output("#{bin}/tsp --list=input 2>&1")
    %w[craft file hls http srt rist].each do |str|
      assert_match "#{str}:", input
    end
    output = shell_output("#{bin}/tsp --list=output 2>&1")
    %w[ip file hls srt rist].each do |str|
      assert_match "#{str}:", output
    end
    packet = shell_output("#{bin}/tsp --list=packet 2>&1")
    %w[fork tables analyze sdt timeshift nitscan].each do |str|
      assert_match "#{str}:", packet
    end
  end
end