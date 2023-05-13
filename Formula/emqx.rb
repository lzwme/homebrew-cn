class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://ghproxy.com/https://github.com/emqx/emqx/archive/refs/tags/v5.0.25.tar.gz"
  sha256 "05e414ff5a803531084ceaa7ef01a7e678d996042f1ecd2c4f9d6d091b92f8df"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "47dec9f11089ffc2cb6adfd22b8aa4faf966a435ef49613b6bf8c25ebce5b783"
    sha256 cellar: :any,                 arm64_monterey: "dc8025d931ae1f9988aec75c2e4c7ace2470c489b53a825c3bf20ad70ff3f9b6"
    sha256 cellar: :any,                 arm64_big_sur:  "c4d6fd308c5757478498dfa321f4226300f8af4fe72e57962b8a2933a087f6ea"
    sha256 cellar: :any,                 ventura:        "474a939f0b45737ded339866bc09926ee348ec10a7c61df24677234d433854a3"
    sha256 cellar: :any,                 monterey:       "5b1e41571e0f2529c3208cb9f308d15f8bf9ad376b4984669d2eaa9f8e136d4d"
    sha256 cellar: :any,                 big_sur:        "5caea4a49ab02168fc2f6d3b5a9b554281b19eea7b7b243a46afeefd51ac9342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c00a70bc0df1527275e2ae20fcae85e9750c6514c3879a221b25fbadfd5a057"
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