class Wireshark < Formula
  desc "Network analyzer and capture tool - without graphical user interface"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.6.4.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.6.4.tar.xz"
  sha256 "fbeab3d85c6c8a5763c8d9b7fe20b5c69ca9f9e7f2b824bedc73135bdca332e2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  # Upstream indicates stable releases with an even-numbered minor (see:
  # https://wiki.wireshark.org/Development/ReleaseNumbers).
  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/href=.*?wireshark[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "b06ccbfaf7de9dab53effd709750f0157fe6cd01236b5f11c17f14d8e03d753e"
    sha256                               arm64_sequoia: "cfd9015fb7a9e4498df537c69ac395b5d8b4b53b0887cff0241114286cb199ea"
    sha256                               arm64_sonoma:  "5f368a3253b16c5419f9c904524106aeb55a2d4af492c5faed3b9623eebef54f"
    sha256                               sonoma:        "d4571034a1f8e53852cc728a41f36240139d3b14c81413468c8cef09d8a73ce6"
    sha256                               arm64_linux:   "c102409ccfabafdb24cde73b68690a7c75fdfcd784960b8ee30d09bf12819352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f50e9cf5822d3baf7a521c0a70d3148297d4ccf0e56a67bab31cd197b451603c"
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libmaxminddb"
  depends_on "libnghttp2"
  depends_on "libnghttp3"
  depends_on "libsmi"
  depends_on "libssh"
  depends_on "lua@5.4" # Lua 5.5 issue: https://gitlab.com/wireshark/wireshark/-/issues/21060
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "speexdsp"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "wireshark-app"

  def install
    lua = Formula["lua@5.4"]
    plugindir = lib/"wireshark/plugins/#{version.major}-#{version.minor}"
    args = %W[
      -DENABLE_BROTLI=OFF
      -DENABLE_SNAPPY=OFF
      -DLUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DCARES_INCLUDE_DIR=#{Formula["c-ares"].opt_include}
      -DGCRYPT_INCLUDE_DIR=#{Formula["libgcrypt"].opt_include}
      -DGNUTLS_INCLUDE_DIR=#{Formula["gnutls"].opt_include}
      -DMAXMINDDB_INCLUDE_DIR=#{Formula["libmaxminddb"].opt_include}
      -DBUILD_wireshark=OFF
      -DBUILD_logray=OFF
      -DENABLE_APPLICATION_BUNDLE=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"wireshark/extcap")}
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: plugindir/"codecs")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "Development"
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Wireshark.app with Homebrew Cask:
        brew install wireshark-app

      If your list of available capture interfaces is empty
      (default macOS behavior), install ChmodBPF:
        brew install --cask wireshark-chmodbpf
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdio.h>
      #include <ws_version.h>

      int main() {
        printf("%d.%d.%d", WIRESHARK_VERSION_MAJOR, WIRESHARK_VERSION_MINOR,
               WIRESHARK_VERSION_MICRO);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/wireshark", "-o", "test"
    output = shell_output("./test")
    assert_equal version.to_s, output
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end