class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https:www.emqx.io"
  url "https:github.comemqxemqxarchiverefstagsv5.8.2.tar.gz"
  sha256 "70e008856836c437c82f4123cf3c353d91dfd64b66ef27bba7924fe6ecec5c45"
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
    sha256 cellar: :any,                 arm64_sequoia: "f0f5534af44d92db903230fc02dd3ec3ec190417c4f3d063ff038ae20291a412"
    sha256 cellar: :any,                 arm64_sonoma:  "72b0c2453957e3865d4e251bb1622a994a53e9a017be6395598c95aa588d9ff3"
    sha256 cellar: :any,                 arm64_ventura: "13be08bbbd359884186010f505817cf30fda49bfb809f57979e4136b7a3e600d"
    sha256 cellar: :any,                 sonoma:        "5743534ae79346a53bb7d9fe9f70e17edc0b9c1c4240de6d36d797d743dc920f"
    sha256 cellar: :any,                 ventura:       "8f6d76aba2c0116f1dbb2cafdc2d3474e6958e84b35637c1d5d754db7734f75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fed0430de39d50c5c60ef4d38b5d8646095b03775e6fa48d676d34623b66ca22"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang@26" => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@3"

  uses_from_macos "curl"       => :build
  uses_from_macos "unzip"      => :build
  uses_from_macos "zip"        => :build
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"

  on_linux do
    depends_on "ncurses"
    depends_on "zlib"
  end

  conflicts_with "cassandra", because: "both install `nodetool` binaries"

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

  service do
    run [opt_bin"emqx", "foreground"]
  end

  test do
    exec "ln", "-s", testpath, "data"
    exec bin"emqx", "start"
    system bin"emqx", "ctl", "status"
    system bin"emqx", "stop"
  end
end