class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://ghproxy.com/https://github.com/etr/libhttpserver/archive/0.19.0.tar.gz"
  sha256 "b108769ed68d72c58961c517ab16c3a64e4efdc4c45687723bb45bb9e04c5193"
  license "LGPL-2.1-or-later"
  head "https://github.com/etr/libhttpserver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b11af50845ce2a87984d6240d3d7db441be82f84fde6fc6447866cc0dd5e6236"
    sha256 cellar: :any,                 arm64_monterey: "ce9d31e81bfbc06990ae1b57b295278e341d5917e157688d999f48c102ec4fba"
    sha256 cellar: :any,                 arm64_big_sur:  "48dae7ff73d5edc565cf97ce6c3f1f9a441e333d3ba0021602add200c3e316f4"
    sha256 cellar: :any,                 ventura:        "4bfcce305d2fb4ae798d9b5a0ce54bf7bfc3a6a3636f7a500dee69ecd3161e32"
    sha256 cellar: :any,                 monterey:       "2eb240316761233c156364b47f7e5a1d0a280baaad49530f5e27ae7f19969db5"
    sha256 cellar: :any,                 big_sur:        "f79987ebd2cc129a3ff7a6ee5f3e4ba62cd3926a5fa66554b6b6c32a70661e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d0e06fdd786113649df4bb86729c6fd53c94b77cb6985a0aa43831cdbbb43bc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"

  uses_from_macos "curl" => :test

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    system "./bootstrap"
    mkdir "build" do
      system "../configure", *args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    port = free_port

    cp pkgshare/"examples/minimal_hello_world.cpp", testpath
    inreplace "minimal_hello_world.cpp", "create_webserver(8080)",
                                         "create_webserver(#{port})"

    system ENV.cxx, "minimal_hello_world.cpp",
      "-std=c++17", "-o", "minimal_hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"

    fork { exec "./minimal_hello_world" }
    sleep 3 # grace time for server start

    assert_match "Hello, World!", shell_output("curl http://127.0.0.1:#{port}/hello")
  end
end