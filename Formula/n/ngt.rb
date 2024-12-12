class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https:github.comyahoojapanNGT"
  url "https:github.comyahoojapanNGTarchiverefstagsv2.3.5.tar.gz"
  sha256 "dd81573260f61bf5c2567fe11ce2d20ac5ab09189151e54463874ecce5b1277a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ffdd346f916a98c3ab64c05c2a3f8d225514b0636f4821662a9915d3b364fed4"
    sha256 cellar: :any,                 arm64_sonoma:  "22aa521f092efa38ebb622796a013ae88d00615ab013fdad5facac26cd456f1a"
    sha256 cellar: :any,                 arm64_ventura: "1b2198990e4b478ae76aab9063aebd342c8740ae2a8ab9b8739a5d9b5da299fd"
    sha256 cellar: :any,                 sonoma:        "e89be2622fd1447633dcfb119d7b3130eda6c2de9865c5ae2b786c890093b2ad"
    sha256 cellar: :any,                 ventura:       "ec54110b91770c42e909f02dede65a537e065923d5b6c80e82f1573426cbc99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed402d08ef59b1986911e971bd9c4f2347d4e2da7318cfa62247aa8155217ae6"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNGT_BFLOAT_DISABLED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare"data"), testpath
    system bin"ngt", "-d", "128", "-o", "c", "create", "index", "datasift-dataset-5k.tsv"
  end
end