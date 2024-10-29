class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https:www.emqx.io"
  url "https:github.comemqxemqxarchiverefstagsv5.8.1.tar.gz"
  sha256 "ff58eef9dceb65047f172032c552e72bf311b0c667bcde044f972bf2a49f712b"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "068c30053dcc4a9ad268627b50fa84408ea0164100d9aa2a2a925818485ccc99"
    sha256 cellar: :any,                 arm64_sonoma:  "0d492410e1c49a92a59779ccedcc7cd9c920dd5860769890af0f096060914088"
    sha256 cellar: :any,                 arm64_ventura: "fe27edc1be88ed5b42d8e61e5eae51e694ba34ae45aade8dee4374f248f492ad"
    sha256 cellar: :any,                 sonoma:        "ac76d2b8b3f8ce4a701e33f2e066d0e265a51b8811082a20ba1754b7f886736e"
    sha256 cellar: :any,                 ventura:       "2651c9426643443198ec883d510fd2e1ed8bb9662fffe0e2e20a527393c86ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "260ff9c31a5a75171fcad6c923d2a0634ac4713af8ea19db08ec4774439edc54"
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