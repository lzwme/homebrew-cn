class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https:www.emqx.io"
  url "https:github.comemqxemqxarchiverefstagsv5.8.3.tar.gz"
  sha256 "4f7ec07d4b14c6f5538b41550992136d87fd8849b41b11316efe4ccb02ebd404"
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
    sha256 cellar: :any,                 arm64_sequoia: "de7ac12bd6862280840b30c461ced61be0347b70eeff865adff1ec81f53d91de"
    sha256 cellar: :any,                 arm64_sonoma:  "1dc23c7e867eaf2abd7762e34bccc5591a6dacf521cd225bddcb920bcf3bef9a"
    sha256 cellar: :any,                 arm64_ventura: "73699c96479d6d9ebe6e880381bf84c2fb68008f714c4ec86ce107796fe8567c"
    sha256 cellar: :any,                 sonoma:        "702618191a78bec821b3943b966e336dc8bbf80452a0c473c035eeba153cddbd"
    sha256 cellar: :any,                 ventura:       "7b654beed37bf7a0c66b03bcfe934527e2d98d1d812bd71b29717b3e34ae8377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dcb61a2b0b9d5ac1c10c8b00c20ae142359edfb4de629e0d61f3ea324bc32f0"
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