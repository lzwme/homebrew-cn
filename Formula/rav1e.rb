class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/xiph/rav1e/archive/v0.6.4.tar.gz"
    sha256 "33aaab7c57822ebda9070ace90a8161dbadf8971f73b53d4db885e8b5566a039"

    # keep the version in sync
    resource "Cargo.lock" do
      url "https://ghproxy.com/https://github.com/xiph/rav1e/releases/download/v0.6.3/Cargo.lock"
      sha256 "f22049598eb6f9948b4d852850eeb48c1236a7a068692db85cbfe72b94498581"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a63543ff9a7fb5ad55e4b8708ffc9cbb55e7015d67cdc96c550ad90fda546fa2"
    sha256 cellar: :any,                 arm64_monterey: "a51aeeec31da65f9d0c715854001732f34a58386eb63841f1d6c823ebdb95330"
    sha256 cellar: :any,                 arm64_big_sur:  "9d486769a624ae14c16de60f3407c3a1c5448adbb5bb1104f6d418735c9f21f2"
    sha256 cellar: :any,                 ventura:        "5969b152809afecd92f74a0a80c606a10bd4e26e3dc217a038ed76a3f9bbabf6"
    sha256 cellar: :any,                 monterey:       "10fff4d58533500bba28ba123fa984cc194e4948f8101309ca4d68239aee579d"
    sha256 cellar: :any,                 big_sur:        "64a5c084863764be09d3b000b8a1d7b39ac3aaf96222d72ee97a1e67a845086e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b628944c272a9715b89dd02ca9f6cff3e66c46c4a7b6e8cff284e1c349b01be9"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "homebrew-bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    buildpath.install resource("Cargo.lock") if build.stable?
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    resource("homebrew-bus_qcif_7.5fps.y4m").stage do
      system "#{bin}/rav1e", "--tile-rows=2",
                                   "bus_qcif_7.5fps.y4m",
                                   "--output=bus_qcif_15fps.ivf"
    end
  end
end