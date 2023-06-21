class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://ghproxy.com/https://github.com/emqx/emqx/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "6fe363125d52eabaf4c830cdf88bdb54d11260aefc61ecd96a610a98985cd447"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60da9e669b8f15c867c05b1e7159d50ccd4520c3175dd7993d2ca3bbb47b92e0"
    sha256 cellar: :any,                 arm64_monterey: "52abd2223b7183aca850c1bf7aaa3b8873ee8ec2341d255ea3eac4ced48fd492"
    sha256 cellar: :any,                 arm64_big_sur:  "aa91a6f0b8c02d205fb2b19ae29fe581670a3a36b3fd707dcf1fdd12ad48eb89"
    sha256 cellar: :any,                 ventura:        "5c44ed89dfc45ff9f400ad7e38f4418df8b5e1aa1c88cc279fdd16f6c5144644"
    sha256 cellar: :any,                 monterey:       "0827c3f6833fdd81d9c5baf27d25bec67f6a194a899c72c16c192ba70c6e1727"
    sha256 cellar: :any,                 big_sur:        "213324dca12d1068149bbed3a8ad854d5abe58aa91601cce9878f74be8a0d052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d5061a3462b99b2e497001d9737e9ab36777a1100a58d0dcd6c376a2cb091f1"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang"    => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"  => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "zip"   => :build

  on_linux do
    depends_on "ncurses"
    depends_on "zlib"
  end

  def install
    ENV["PKG_VSN"] = version.to_s
    touch(".prepare")
    system "make", "emqx"
    prefix.install Dir["_build/emqx/rel/emqx/*"]
    %w[emqx.cmd emqx_ctl.cmd no_dot_erlang.boot].each do |f|
      rm bin/f
    end
    chmod "+x", prefix/"releases/#{version}/no_dot_erlang.boot"
    bin.install_symlink prefix/"releases/#{version}/no_dot_erlang.boot"
  end

  test do
    exec "ln", "-s", testpath, "data"
    exec bin/"emqx", "start"
    system bin/"emqx_ctl", "status"
    system bin/"emqx", "stop"
  end
end