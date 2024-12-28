class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https:github.comrakshasalibtorrent"
  url "https:github.comrakshasalibtorrentarchiverefstagsv0.15.0.tar.gz"
  sha256 "f55fb872282a2964049dadb89c4d1fb580a1cef981b9a421991efd5282ca90b7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4cdc68e1d6fab8dcee7d8b2679c1f4d43dd21a3f9ca180370f76fd62062e8b17"
    sha256 cellar: :any,                 arm64_sonoma:  "74bc68d4ad3dc30bc1c4759894da0c5f8898d821a971421f6373ffdeaf47ebc2"
    sha256 cellar: :any,                 arm64_ventura: "b09e4b71ea6b6338a5caa1075477fb69e839e05d868130ccbfb801de577cc52e"
    sha256 cellar: :any,                 sonoma:        "2dd4052aaaede389acbf44a58eedc885a827e663fe61cf8fedbe92399627d5ae"
    sha256 cellar: :any,                 ventura:       "5ea6e155be088cb5bfd7aa6a5e7cc2460454d5d8ef74eb49c280a6945f46c74d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e349c6510275e9aca4848400949966c16efd9fe26cb59b8dd4f97e518452110e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar", because: "they both use the same libname"

  # build patch to remove `rak::equal` and `rak::mem_ref` refs, upstream pr ref, https:github.comrakshasalibtorrentpull285
  patch do
    url "https:github.comrakshasalibtorrentcommit59ea9a985083c6c933cb9fe28d6e2d1579f337da.patch?full_index=1"
    sha256 "3e4d2eee017228193a07f1ba9d9c4ebb0c36d5f78fba62b1c39f57e4cfe7d15f"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <string>
      #include <torrenttorrent.h>
      int main(int argc, char* argv[])
      {
        return strcmp(torrent::version(), argv[1]);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    system ".test", version.to_s
  end
end