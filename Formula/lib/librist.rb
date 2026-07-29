class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.19/librist-v0.2.19.tar.gz"
  sha256 "ad084179295ea3a53ee62f18dda8752825300b40c41c91c215e0624907514246"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d7a94c664a149243fdb2dbc0f87c8aa68570c9307929c8baf5fcc89d7a37f55"
    sha256 cellar: :any, arm64_sequoia: "eecd7e90448633ff9ab4082d42b49ebc50eae848cfc9db2dfc84d758fe73b35b"
    sha256 cellar: :any, arm64_sonoma:  "d03fa7b031cf5ae0c30dbfd4cab4d4caf3ae1ee5c80ae58b6402e17b54957df2"
    sha256 cellar: :any, sonoma:        "944dcd248fa72a0bff467826fd32acfe31ec533d3a32750fe51fedf564004e33"
    sha256               arm64_linux:   "2b14928ea2b38464542f0ee02c9ef92804b8480266fde00f277faba9484b5836"
    sha256               x86_64_linux:  "2986de8f579da1ac07e2359ed05d445264c8cfa704538643ac58c22993f5645e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libmicrohttpd"
  depends_on "lz4"
  depends_on "mbedtls@3"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"

    system "meson", "setup", "--default-library", "both", "-Dfallback_builtin=false", *std_meson_args, "build", "."
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end