class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://ghfast.top/https://github.com/uber/h3/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "b88de0212058812f560c21517e62cd6b2d146f5382b9cc1316bd45c1a3334239"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3c0e8b5eeef3523d7859c3a505752f247fd65ef835a168c58d7f542cfcda1fd"
    sha256 cellar: :any,                 arm64_sequoia: "cef5746194581704909fa8cf45d44b8384c87f32212f73141afc6491b4854d11"
    sha256 cellar: :any,                 arm64_sonoma:  "bd79befd917bf043454c29808365c7d1517ac35a6036661010b3d688f628adf8"
    sha256 cellar: :any,                 sonoma:        "f1ffe70016a9a8a506a767c9505ed120205c1bead0153398fae0886ac5debd11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8752621d70e55924f1b11e82719c5efa6d1f7da19e0d879289f4784c49366ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114e43655d7022d59aa8dbb724bd7071e7ff874a077015bf322707fe77f2aff4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    result = pipe_output("#{bin}/latLngToCell -r 10 --lat 40.689167 --lng -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end