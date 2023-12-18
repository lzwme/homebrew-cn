class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https:www.emqx.io"
  # TODO: Check if we can use unversioned `erlang` at version bump:
  #   https:github.comemqxemqxblobv#{version}scriptsensure-rebar3.sh#L9
  url "https:github.comemqxemqxarchiverefstagsv5.3.2.tar.gz"
  sha256 "0010c9bd981734a9ef7851f57572cef8483deddfa1675a96e652797f064d1960"
  license "Apache-2.0"
  head "https:github.comemqxemqx.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "02757787eb2c7fab318411d437556552c372a1eb9c49adb6d74cb67ad4e5f646"
    sha256 cellar: :any,                 arm64_ventura:  "eab5f64919f17f5e69f92a8dd36a6c580557cec8ccb71fc0319570ee2c8125a8"
    sha256 cellar: :any,                 arm64_monterey: "4da91fb38d4ce50323c1762e01f8588ed4f27d4b211365e0d7a12f80502d920d"
    sha256 cellar: :any,                 sonoma:         "e9d7d828b28968539cd62fd35813a97ceeab00e491d114e1722fa020ad1780bb"
    sha256 cellar: :any,                 ventura:        "4a3455430d3523fa0f115df7ba6b63df9c33a74ed7790c6b9e2f50997f6d2959"
    sha256 cellar: :any,                 monterey:       "0b89a8c6b126dfad7bdf1569182492c11525d19adf80b0e93936df5606269c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fbae30c3845e58b71fbbb6fb3ceed2431c8c5eefd1e320ef72f08224724638b"
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
    prefix.install Dir["_buildemqxrelemqx*"]
    %w[emqx.cmd emqx_ctl.cmd no_dot_erlang.boot].each do |f|
      rm binf
    end
    chmod "+x", prefix"releases#{version}no_dot_erlang.boot"
    bin.install_symlink prefix"releases#{version}no_dot_erlang.boot"
    return unless OS.mac?

    # ensure load path for libcrypto is correct
    crypto_vsn = Utils.safe_popen_read("erl", "-noshell", "-eval",
                                       'io:format("~s", [crypto:version()]), halt().').strip
    libcrypto = Formula["openssl@3"].opt_libshared_library("libcrypto", "3")
    %w[crypto.so otp_test_engine.so].each do |f|
      dynlib = lib"crypto-#{crypto_vsn}privlib"f
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
    exec bin"emqx", "start"
    system bin"emqx", "ctl", "status"
    system bin"emqx", "stop"
  end
end