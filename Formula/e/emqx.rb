class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https:www.emqx.io"
  url "https:github.comemqxemqxarchiverefstagsv5.6.0.tar.gz"
  sha256 "e323f053af0dcccf9bac4b3c49638b7c38c7df2d5bd02bbf6de2fcc5e3bc3f8f"
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
    sha256 cellar: :any,                 arm64_sonoma:   "63bfa1052da46c51594470adb1d85bfa2179fdfcde9758a2065fc80eb9df7bb3"
    sha256 cellar: :any,                 arm64_ventura:  "e3350910ed621712cf4d4636707c3ef5e319c40b00c3cad22f28009d2b1171b6"
    sha256 cellar: :any,                 arm64_monterey: "e9370fcbdeead432fce50a6419d4a4f66c8f2d8576f1ccb4db9ff92bd65b4828"
    sha256 cellar: :any,                 sonoma:         "4b0b3f3bb120fc87ec359c06e221e6ced943708eed41643a079bb877af364e93"
    sha256 cellar: :any,                 ventura:        "1eac793859a837f0cc7154fe3df32a14f900fbfb7ea397f84fca0034344230c0"
    sha256 cellar: :any,                 monterey:       "4d4ae93c6880bd54d87e6ae9f9268f045db238d2cacda5446cae735cf98cef14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff107f73c6dcf4102c09477311808fceb7d3e17a176208d4c65d14ed5ac00f5a"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang" => :build
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