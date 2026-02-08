class Fastga < Formula
  desc "Pairwise whole genome aligner"
  homepage "https://github.com/thegenemyers/FASTGA"
  url "https://ghfast.top/https://github.com/thegenemyers/FASTGA/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "391a86ff3b9355f677e891fed23f3b9524b82f88b9905f1b482ce1144add1ab5"
  license all_of: ["BSD-3-Clause", "MIT"]
  head "https://github.com/thegenemyers/FASTGA.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f0b6daa41a3e30a34b17096e2e2c00f5497d25bccf07f9f5d93970cb87c6690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaabe46cde2f90f0e449a516446b020ba355f3ff00d6b4e2ace449fc7f76dc30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "624c69a324de1184fd08f68c1fc17f3c2cc7ba3020d7b8e97f7dd28a0008809c"
    sha256 cellar: :any_skip_relocation, tahoe:         "63abe45f86abc9a5863e41c7893618a3fa0b9c588e774ce2cb7b175703ac6058"
    sha256 cellar: :any_skip_relocation, sequoia:       "d0bc4b02220b470fa1ee9357ac16f80fa84066a5e529994412b6c768db335d6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5af73f9b8fc0b65e7c8d936257755dba73802bb05a141395d57e3366bb26c58d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a61e8adbad41553ba190ff117879a3c0e65196ac23bc6f442acc002c0087866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e75ecc88983432af3b66eb378c1d227c64d707d23313652eb577b084f66cd23b"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    bin.mkpath
    system "make"
    system "make", "install", "DEST_DIR=#{bin}"
    pkgshare.install "EXAMPLE"
  end

  test do
    cp Dir["#{pkgshare}/EXAMPLE/HAP*.fasta.gz"], testpath
    system bin/"FastGA", "-vk", "-1:H1vH2", "HAP1", "HAP2"
    assert_path_exists "H1vH2.1aln"
  end
end