class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://ghproxy.com/https://github.com/emqx/emqx/archive/refs/tags/v5.0.18.tar.gz"
  sha256 "86fd7cad7d62630eb7ae6eb8ecb6a92d298695fe72bc8a2c15630629712bf4fb"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eb4f94da1381050c784008588a5aa1a911e1b1c39cb47b9426aa702e013cf407"
    sha256 cellar: :any,                 arm64_monterey: "9871ec00872f2bbbaddb80a68c344b00b57599af5acb4474803844e06929b22e"
    sha256 cellar: :any,                 arm64_big_sur:  "105cec3621588c9bddec6e527cd13b55d4f43c809f49e10b9cbb7341399a1e9c"
    sha256 cellar: :any,                 ventura:        "689ec46e432da9d973d6fd9a4b8101efc69a231e7c6a8517cf7118e4fb76cce1"
    sha256 cellar: :any,                 monterey:       "db2c17c47e91da1baadfd87b78ceb8b82b93708a614b5f3a68e9162c612fefa1"
    sha256 cellar: :any,                 big_sur:        "0fa1625af02ebf0f5efef6142ebb62f48e8757d59c7a86fd976dee1d4792e144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ea149ff090474f9de75d33f3ca347be57256e5bc46d00b5d68c6f0f46a60b4"
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