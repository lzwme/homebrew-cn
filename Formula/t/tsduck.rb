class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https:tsduck.io"
  url "https:github.comtsducktsduckarchiverefstagsv3.38-3822.tar.gz"
  sha256 "18bb779584384197dbb72af406cdcd42fe06efbf4a6ca8fd3138eb518b7ad369"
  license "BSD-2-Clause"
  head "https:github.comtsducktsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "08d89289310279ea56e591018041d2303bbd041db7c3f2c43b63fd41519e8ab8"
    sha256 cellar: :any,                 arm64_ventura:  "301e4fd189875c64fdf14aeed0c1e1da7f2e202f6effa4d9440cc18e809665b3"
    sha256 cellar: :any,                 arm64_monterey: "2717f6e274d85c697158cc668f11cfbabd6a785acfe3cafa612d3ac70a6316e4"
    sha256 cellar: :any,                 sonoma:         "95ba7168007b31e91fb79a58f5da004c9a24dd001a9ded7d8e106764c9c49495"
    sha256 cellar: :any,                 ventura:        "71f12d1776f92aaad21655510a7fe9f010d147a05c55032a6f8f19e14cc3217a"
    sha256 cellar: :any,                 monterey:       "56afe9a27b1d8305add0b26932e27179e2211d986d9d3e14e34d149704568e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e572022bf14d2cf4390e577a0135232fbe7323644be64cb602959c48095dc4d0"
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

  def install
    ENV["LINUXBREW"] = "true" if OS.linux?
    system "make", "NOGITHUB=1", "NOTEST=1"
    ENV.deparallelize
    system "make", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}"
  end

  test do
    assert_match "TSDuck - The MPEG Transport Stream Toolkit", shell_output("#{bin}tsp --version 2>&1")
    input = shell_output("#{bin}tsp --list=input 2>&1")
    %w[craft file hls http srt rist].each do |str|
      assert_match "#{str}:", input
    end
    output = shell_output("#{bin}tsp --list=output 2>&1")
    %w[ip file hls srt rist].each do |str|
      assert_match "#{str}:", output
    end
    packet = shell_output("#{bin}tsp --list=packet 2>&1")
    %w[fork tables analyze sdt timeshift nitscan].each do |str|
      assert_match "#{str}:", packet
    end
  end
end