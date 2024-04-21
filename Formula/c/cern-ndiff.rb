class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment.
  homepage "https:mad.web.cern.chmad"
  url "https:github.comMethodicalAcceleratorDesignMAD-Xarchiverefstags5.09.02.tar.gz"
  sha256 "f3cf8b45eb6e8a7b85e19c4b80786d8ced2558b368991fa62bb0658d35abd91d"
  license :cannot_represent
  head "https:github.comMethodicalAcceleratorDesignMAD-X.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38c8adf14474e1ee2747a843a6eb608ed26fa760bba14a99c142ba71e963a543"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1081deca19a01dcd668b47498bb4cb53c00296ea92476a38acadf54eb0d59373"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f70a7b38089bdc14c3199c9f44e767cb586ffade51bc0263e06e955041773eba"
    sha256 cellar: :any_skip_relocation, sonoma:         "b770caf7c06371aa6d6ebe89a78097dbf2c50ddf76af0729e762707129618898"
    sha256 cellar: :any_skip_relocation, ventura:        "c30728fa01d17a9a23a2b7d3c11b3fe199b9231874de09915ea006800bc72622"
    sha256 cellar: :any_skip_relocation, monterey:       "43e7a7753dd6cef3e8d1dece169e57b5ee7f937feb72fee04baa6e0a60489dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "959668f2d3528da6c2ddf5fb6b622a817e25cd6de5ca9b6b0504cd0977313385"
  end

  depends_on "cmake" => :build

  conflicts_with "ndiff", "nmap", because: "both install `ndiff` binaries"

  def install
    system "cmake", "-S", "toolsnumdiff", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"lhs.txt").write("0.0 2e-3 0.003")
    (testpath"rhs.txt").write("1e-7 0.002 0.003")
    (testpath"test.cfg").write("*   * abs=1e-6")
    system "#{bin}ndiff", "lhs.txt", "rhs.txt", "test.cfg"
  end
end