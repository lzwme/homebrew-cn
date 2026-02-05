class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://ghfast.top/https://github.com/tsduck/tsduck/archive/refs/tags/v3.43-4549.tar.gz"
  sha256 "a3399661d21e0d965dfef3750d4af7da61eb2924e7b48ee3edaae194ffa5203c"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0748c78d1f5ee0e5e2c5b06817620a2c43bb0ab5d81d4d0662be07f88a89aaa2"
    sha256 cellar: :any,                 arm64_sequoia: "8ab669be5e06d283575341a204ca7b2bf78b6c3018e4a94fd6b42a4d5e36b6c1"
    sha256 cellar: :any,                 arm64_sonoma:  "89a86a67809a853f1fbcd8366cd11707b577b88b7b06c8eb2e285c715b5fc17c"
    sha256 cellar: :any,                 sonoma:        "4968c1137bd05430e330b3e9c593db20671ea1380ded6421c91a0ce86fec8b8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b99ef57d25c736d33c9cff260a9db2fc9c0695cfc26cf84fbcc6328f75a5e352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d2448cd03a63c3f356d34303d89dc17c9fbffb42b3ff9036131da764bdedb6"
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

  # Add sys/time.h header
  # PR ref: https://github.com/tsduck/tsduck/pull/1689
  patch do
    url "https://github.com/tsduck/tsduck/commit/c46fd301f31be8c9aa00ce6d6e21c4e4c6bfc1cf.patch?full_index=1"
    sha256 "c20a1989f2fb528c5326e088beac78cae438c9ea00a93c4b6d04400df7b4ff77"
  end

  def install
    if OS.linux?
      ENV["LINUXBREW"] = "true"
      ENV["VATEK_CFLAGS"] = "-I#{Formula["libvatek"].opt_include}/vatek"
    else
      ENV["LDFLAGS_EXTRA"] = "-Wl,-rpath,#{rpath(source: lib/"tsduck")}"
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