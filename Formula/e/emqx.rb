class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  # TODO: Check if we can use unversioned `erlang` at version bump:
  #   https://github.com/emqx/emqx/blob/v#{version}/scripts/ensure-rebar3.sh#L9
  url "https://ghproxy.com/https://github.com/emqx/emqx/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "433397123eaba945807c0965e3fc600f7f191d52db9a2e7c981f8c1476944071"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84fee39ca004ff23d425b723afa2a03e62cedd23924ee639938790ee916898ad"
    sha256 cellar: :any,                 arm64_monterey: "1cfd830466e406972064a62046df166140694829cdbb36660770ab62e07594d3"
    sha256 cellar: :any,                 arm64_big_sur:  "761a1aa7aff9ba127d52b934152c5088eed306c9201fb0136aa45bbab0214fdc"
    sha256 cellar: :any,                 ventura:        "58c15fb4f9e02cb6a2251c1ed7bb44e5affe7de40e739c90c903f4bcdadcc78c"
    sha256 cellar: :any,                 monterey:       "dbdaf9f1cc6a66de849a132e7402df06f4da3abe2abd73691ef0cb0343a03e68"
    sha256 cellar: :any,                 big_sur:        "b3a11190b9dc2ecb9d89d95cb81a4714108be82eb7da34826a0438e0d7b3460a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e0303ee3218e2fe53d33c161d71b272382c1e3a318626e3003edb113fa3f0d"
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
    ENV["BUILD_WITHOUT_QUIC"] = "1"
    touch(".prepare")
    system "make", "emqx-rel"
    prefix.install Dir["_build/emqx/rel/emqx/*"]
    %w[emqx.cmd emqx_ctl.cmd no_dot_erlang.boot].each do |f|
      rm bin/f
    end
    chmod "+x", prefix/"releases/#{version}/no_dot_erlang.boot"
    bin.install_symlink prefix/"releases/#{version}/no_dot_erlang.boot"
    return unless OS.mac?

    # ensure load path for libcrypto is correct
    crypto_vsn = Utils.safe_popen_read("erl", "-noshell", "-eval",
                                       'io:format("~s", [crypto:version()]), halt().').strip
    libcrypto = Formula["openssl@3"].opt_lib/shared_library("libcrypto", "3")
    %w[crypto.so otp_test_engine.so].each do |f|
      dynlib = lib/"crypto-#{crypto_vsn}/priv/lib"/f
      old_libcrypto = dynlib.dynamically_linked_libraries(resolve_variable_references: false)
                            .find { |d| d.end_with?(libcrypto.basename) }
      next if old_libcrypto.nil?

      dynlib.ensure_writable do
        dynlib.change_install_name(old_libcrypto, libcrypto.to_s)
        MachO.codesign!(dynlib) if Hardware::CPU.arm?
      end
    end
  end

  test do
    exec "ln", "-s", testpath, "data"
    exec bin/"emqx", "start"
    system bin/"emqx", "ctl", "status"
    system bin/"emqx", "stop"
  end
end