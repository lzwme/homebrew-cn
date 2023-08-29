class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  # TODO: Check if we can use unversioned `erlang` at version bump
  url "https://ghproxy.com/https://github.com/emqx/emqx/archive/refs/tags/v5.1.4.tar.gz"
  sha256 "e9c5a8f98a3b142211fcc83de6b6c7251677a71d27b207d08ca6cb07c77afc0d"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b0538b6fc96c952ab0ef08c12244ed67e81207d25474a66ff74b12964fe33a6f"
    sha256 cellar: :any,                 arm64_monterey: "425b75e7b054ae69d82598e20e874db7dcfd2a0f088854b3cd5156c2cc779993"
    sha256 cellar: :any,                 arm64_big_sur:  "7a9d54ffa509924a16b8112fac9996aa3a79f48ca3d0dfae6a059eb54f95f12d"
    sha256 cellar: :any,                 ventura:        "56d5c24a6d7251c53a81ca2904cd47cf7c1e2b5a9320006a5b75447011a8a499"
    sha256 cellar: :any,                 monterey:       "89c1220622eaf2de6359cd344df4d9f82f39108763fbd8732bc3bce2770b79b2"
    sha256 cellar: :any,                 big_sur:        "17a7f50d14c4fcf0f61d7e92f18f798d6ddaaf62c9d6c18b4f07f5ed854936e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4643fc1925237846813abd1e748364928ce020f50c705d56db483d4d662276b1"
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