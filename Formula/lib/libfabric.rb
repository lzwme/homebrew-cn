class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https:ofiwg.github.iolibfabric"
  url "https:github.comofiwglibfabricreleasesdownloadv1.20.0libfabric-1.20.0.tar.bz2"
  sha256 "7fbbaeb0e15c7c4553c0ac5f54e4ef7aecaff8a669d4ba96fa04b0fc780b9ddc"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https:github.comofiwglibfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "affa007285faac8538e4336ba4900c07088441c4b514c2c3713f0caa7b83525b"
    sha256 cellar: :any,                 arm64_ventura:  "fc00246b0d6b43d3b08aec7da00f43bf1571a2f3cc26e3fd6722b234813ea099"
    sha256 cellar: :any,                 arm64_monterey: "bc63e546ea81aa9d58861b985cbfe5857adf00320940794cd78864af4fa3e909"
    sha256 cellar: :any,                 sonoma:         "d6a96b16b1455a0a272b5086e91cfd90319426060b4a2c5adcd82e431abfb743"
    sha256 cellar: :any,                 ventura:        "d6e9970a454ff01179580a92606226fead51f4f138595278375e3f3b7b4a91e9"
    sha256 cellar: :any,                 monterey:       "35ae162e599cc5649a05a33a757f6062fb9ac7fec51a47ea878394c946911643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "422613d496f554e66a490dfe0c2d34cb245193727f67e64ad1e488f8e3107763"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "-fiv"
    system ".configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}fi_info")
  end
end