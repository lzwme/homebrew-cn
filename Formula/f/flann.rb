class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https:github.comflann-libflann"
  url "https:github.comflann-libflannarchiverefstags1.9.2.tar.gz"
  sha256 "e26829bb0017f317d9cc45ab83ddcb8b16d75ada1ae07157006c1e7d601c8824"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47250c09074574e097f6a58846c183e51d0e36df9409b2d11ed5aee36691b78d"
    sha256 cellar: :any,                 arm64_sonoma:  "a90114e86c64bd05b7804ee9cdd0aa1b7032c4e7604b37bf760b1e2a7ac7b85a"
    sha256 cellar: :any,                 arm64_ventura: "fb161bd13f745de377d0c7da4959a538859a05f1327a4cd1dcc715f753e166e9"
    sha256 cellar: :any,                 sonoma:        "e6173b7028321f243b95cf5fff7335393820585f5563f37cf2b799ad25d19947"
    sha256 cellar: :any,                 ventura:       "f4c22835031da0fe8aec8f176e2b70c086fd34e055a0b662487a810bb282fedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5e0831e7f18820cbb873c5853660e272b7b5d2d4c34d753683bc1ea604707e0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "hdf5"
  depends_on "lz4"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_PYTHON_BINDINGS:BOOL=OFF",
                    "-DBUILD_MATLAB_BINDINGS:BOOL=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-dataset" do
      url "https:github.comflann-libflannfiles6518483dataset.zip"
      sha256 "169442be3e9d8c862eb6ae4566306c31ff18406303d87b4d101f367bc5d17afa"
    end

    testpath.install resource("homebrew-dataset")

    system bin"flann_example_c"
    system bin"flann_example_cpp"
  end
end