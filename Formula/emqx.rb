class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  # TODO: Check if we can use unversioned `erlang` at version bump
  url "https://ghproxy.com/https://github.com/emqx/emqx/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "c77baede35ced8e5bc59ea5e4cd63878f4a5c19b3e31f67f51fbe7bf00815f76"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c08343736c113f68c4c4f9a717a26ad866cdeb9348ffa58de4302ce67d3715f3"
    sha256 cellar: :any,                 arm64_monterey: "7be8ae2ed58dd1459892acb88f5e4da7a53b544710b60447a3b5f59b89647f32"
    sha256 cellar: :any,                 arm64_big_sur:  "23dc78e5e9fa26aa4150ca7ee4cd9dca4f2a6d671c92be759e6dbe54932a5709"
    sha256 cellar: :any,                 ventura:        "b18e36577a049a69a8497e2e8310c5981facd888363e9cb4f49873bd22a9d5be"
    sha256 cellar: :any,                 monterey:       "df51248626a22ea6d3e0080c0b777fa2babb4c776d3530be16f410699298645c"
    sha256 cellar: :any,                 big_sur:        "3ebecd51919a545dc3ae8cedea339f094980194509a49345aa739a6d4de40c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ab8f7c85dcd209c6ae5c418dc89cd3eb04a10677b7420edbb9749759065ba2"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang@25" => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@3"

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