class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https:www.emqx.io"
  url "https:github.comemqxemqxarchiverefstagsv5.4.1.tar.gz"
  sha256 "284d3aa4b2b1993dd727e4a755314573d84c43a78fe70f618ec1f0b4550ac5b1"
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
    sha256 cellar: :any,                 arm64_sonoma:   "39b17e9cde0132cc0ca0487898854e2e7304917fa4cc8fdcde59f8866cdbb29c"
    sha256 cellar: :any,                 arm64_ventura:  "7dc2f7287ff602fab4c4a46fa79c27f363bd1d421bdb8f5f41e5f4a434d3b625"
    sha256 cellar: :any,                 arm64_monterey: "10d6cba1c963ce8d87e3b63f1d495fb61b28a065ce1e6b14c897f72a701814b9"
    sha256 cellar: :any,                 sonoma:         "596ce5c7cb835750bcf3b8703e62f73846e5a35db7234fedfa19b27614ecd618"
    sha256 cellar: :any,                 ventura:        "e2b9deda7b96289c2c2e12029c9ad33ca743952ff2b6e8c8c8310c5a1b36a7fe"
    sha256 cellar: :any,                 monterey:       "add0f537dfd234337de6d84a3479df17966f973db5538a73182b21083ec9c75f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "019b9042939bd484d41fd0088179a7113be60683cee628bbf68e0aefc7e96df0"
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