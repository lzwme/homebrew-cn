class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://ghproxy.com/https://github.com/tsduck/tsduck/archive/refs/tags/v3.35-3258.tar.gz"
  sha256 "7c28d04fad9ef8415dc02d56f377e5b2b4c3f173dcc9487a906ee73da38f4e41"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "0cc0d482dbf87e673963628265f088a77a515ed9417ba1652c45523bcbe7ae2c"
    sha256 cellar: :any,                 arm64_ventura:  "a7e0248e056e1bd5ee2ecd3b22eab57da544b79454c7ac66068517af7a768f8e"
    sha256 cellar: :any,                 arm64_monterey: "0729c92185a3aa5820ee7d484e81552ac7561ef5b8a0326f1cbd704eefbe3fae"
    sha256 cellar: :any,                 sonoma:         "0bfab763e2e3fd6ede6cd5dc776ec4171d72679f73979f810ff42984268cea9a"
    sha256 cellar: :any,                 ventura:        "880887f7c27957f9b3066c62afd41b5aee6ce0781570ac8d8a4fc396fa9d3c72"
    sha256 cellar: :any,                 monterey:       "c3b4cc04b214268702454fe3b2b2daeba24e940cf2fe96cddb6453ac47cf6e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4d97dfd0ea2bc3620c72bd7be5aa6ecaf9cf6f1e452f113e8171686a7be4f3f"
  end

  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "librist"
  depends_on "libvatek"
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