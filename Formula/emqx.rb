class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://ghproxy.com/https://github.com/emqx/emqx/archive/refs/tags/v5.0.24.tar.gz"
  sha256 "ff9afdee1eb4c5e715da70224b8645a0bcb253ff96348e092cff665f4bf3a62f"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad91c45b4541466c990f4faad431c69aa00891bb24243cc8afbb1d626cc0ac9c"
    sha256 cellar: :any,                 arm64_monterey: "69730bf140898751d4f4404f737ac20128c309538ff7de0937e37890b160090b"
    sha256 cellar: :any,                 arm64_big_sur:  "b0a8e22b8e16904df380e73d53ec85f6ab2f49139df99a6dddd9e7ffe1ed2063"
    sha256 cellar: :any,                 ventura:        "b54107e3db7fdf1e86b04d93c983a989adce76a65756e3b8f457ed50147edc16"
    sha256 cellar: :any,                 monterey:       "a4c01c1fe78b44351cbf05d8545125ab56d46bb8e73ddd4b5f4fd59a53ac5416"
    sha256 cellar: :any,                 big_sur:        "8259b757d3fe2ad3b9db7f42e00eb60a1ebbb76ab318adc475d239352259f9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5021a2364e0ee3b6c1c53c491672e2fb99d65ea7eb2fd5ad7ccb018b57db652f"
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
    system "tar", "xzf", "_build/emqx/rel/emqx/emqx-#{version}.tar.gz", "-C", prefix
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