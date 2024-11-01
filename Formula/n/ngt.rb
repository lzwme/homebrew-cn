class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https:github.comyahoojapanNGT"
  url "https:github.comyahoojapanNGTarchiverefstagsv2.3.3.tar.gz"
  sha256 "bae2de9f335b7b77e0f26acbded09bcbc044c1a3195c500913f88bbbecefc144"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c001b7eb910801df5c1ae272c5f8de5e1f33e8a19cb87d889033bbb56e38585f"
    sha256 cellar: :any,                 arm64_sonoma:  "ef0760834da49aab88136ed956f902f62f3b24832f45151961720d2e8818f333"
    sha256 cellar: :any,                 arm64_ventura: "77be863d534a546b7d6098d1b022e46e7d68a8b8deb353b9eafd7c0aaac0a44d"
    sha256 cellar: :any,                 sonoma:        "311c5dee352c0b46c451b1b0014aaf19e370ca7b9dc1ce625cbbc568ee705785"
    sha256 cellar: :any,                 ventura:       "89626b3da9edd8cd2d927ea61a022d7398ad36761612d70a8c24970833ce29f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec3ff94c0b4a38733f06d91e7b86f47a96bd94978f70be362d12bf33ee0a68b"
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