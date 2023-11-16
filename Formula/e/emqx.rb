class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  # TODO: Check if we can use unversioned `erlang` at version bump:
  #   https://github.com/emqx/emqx/blob/v#{version}/scripts/ensure-rebar3.sh#L9
  url "https://ghproxy.com/https://github.com/emqx/emqx/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "11c3fead5af8359da7c55b74a0b4e9fb6a980f9e7b0752684867e65eda897fe9"
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
    sha256 cellar: :any,                 arm64_sonoma:   "7fb1e91d4b9122c97711f792b9138ae5ebc26b77ab7e6b02e7b75d90e10fa5b7"
    sha256 cellar: :any,                 arm64_ventura:  "dae5d83fad67e3615c2c87ef44c032673e2c2c82e0d85e61f21723d8bb9b38b5"
    sha256 cellar: :any,                 arm64_monterey: "619988b669ba5ba42cb3b79cb016f6e218340413d60e557dab1874e2e66452c2"
    sha256 cellar: :any,                 sonoma:         "a05949c3633400cb19aebbc29e78966298264762045fefa75df0386078cde2e1"
    sha256 cellar: :any,                 ventura:        "b1531b793fd5fdbf4fe7b97ddeba4cbe7902f7a973aad335baab460c24c9a216"
    sha256 cellar: :any,                 monterey:       "d9925c8e939934cb92ad37e5e0066d7f26a26636c283fcb0cca4cc907191a521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e499791aafd8dff120dae9ff88ff128ca60c9424c4f1de6dbccb5365e1a1ecd"
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