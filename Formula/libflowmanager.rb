class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "https://github.com/LibtraceTeam/libflowmanager"
  url "https://ghproxy.com/https://github.com/LibtraceTeam/libflowmanager/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ab60c9c9611488e51c14b6e3870f91a191236dced12f0ed16a58cdd2c08ee74f"
  license "LGPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "580edce84318af1d6c9a1fb34e131b54ee82c9f8c949f3fa1e314b240d44f514"
    sha256 cellar: :any,                 arm64_monterey: "a86cc22af11e7199cbdd65a190fb6621b816bf5b01c0e9e6d3cd9f69fa190656"
    sha256 cellar: :any,                 arm64_big_sur:  "85deb8a52e3eb34eaefa5851c1017f77cbad2767968dbb22dc434f1dfba03766"
    sha256 cellar: :any,                 ventura:        "db47efecc48ea69795a1ee1317217d63825d25678ab8a25fdb5da6bd7daa043d"
    sha256 cellar: :any,                 monterey:       "55a184421e4903a2de88d74bfbb7dc46dcdb649778f01ce7e13b1315d8803279"
    sha256 cellar: :any,                 big_sur:        "cb56969ba9c9417ca57ea914fd33358260cdec432b7fae979cfbde80d27ad3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "447c6ca7a8d3774ddc4e5adcb21b9735aff22be9287bb6fbd054e7cd95063286"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libtrace"

  # Fix: tcp_reorder.c:74:30: error: ‘UINT32_MAX’ undeclared (first use in this function)
  # Remove in the next release
  patch do
    url "https://github.com/LibtraceTeam/libflowmanager/commit/a60a04a3b4a12faf48854b34908f9db0c4f080b0.patch?full_index=1"
    sha256 "15d93f863374eff428c69e6e1733bdc861c831714f8d7d7c1323ebf1b9ba9a4c"
  end

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end