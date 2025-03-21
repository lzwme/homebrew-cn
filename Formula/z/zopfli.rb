class Zopfli < Formula
  desc "New zlib (gzip, deflate) compatible compressor"
  homepage "https:github.comgooglezopfli"
  url "https:github.comgooglezopfliarchiverefstagszopfli-1.0.3.tar.gz"
  sha256 "e955a7739f71af37ef3349c4fa141c648e8775bceb2195be07e86f8e638814bd"
  license "Apache-2.0"
  revision 1
  head "https:github.comgooglezopfli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "87b9f0523e7d1233fcaec2d394122f9aab234bf00a026f4f9322b47b1ef8f8ae"
    sha256 cellar: :any,                 arm64_sonoma:   "171ca3e9b77ac8ebac1b2c082c4938d845605d599e30c671003ca3b5f8f0f795"
    sha256 cellar: :any,                 arm64_ventura:  "68ec999fc21b6ea2e0a44fe4a9cb23dc6fbfac6f51ee153b268fd33408f6d801"
    sha256 cellar: :any,                 arm64_monterey: "31f0023436da6f38a1a1df31ca8b2fd82eaac4a7ce1bc2a2b7cf05a0c4ec2f05"
    sha256 cellar: :any,                 arm64_big_sur:  "2f093e34188e4c0b3d7b2acdd913ecc302ba6dafe722f943e579bf70a09ef15a"
    sha256 cellar: :any,                 sonoma:         "cee5a9b397978a707970ca5f9caaa4c5c461effcb3c4291ae74d2e40ac769dc2"
    sha256 cellar: :any,                 ventura:        "ef2f18c71a1473972602aa28fc2e0c508c89336e42633423804877ab33dc6ccb"
    sha256 cellar: :any,                 monterey:       "6f02f39b1b143725890fb1d1a33e6f587daf33ef473ff2991189e2fd1d1a5f85"
    sha256 cellar: :any,                 big_sur:        "64f2102bff6163156d073e4554532c990c3a65669b7a52d2cec83a22d5b32d4c"
    sha256 cellar: :any,                 catalina:       "288d48544556b28451e536b142dcc2235ea9dfe52dfe79d0b1d5f50db85c16dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3424c6b2263832ea51f0b089bc7b8d1bbdfe041006847803ec32a7cc348c67c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6994139461f1d64975551091d1254a906a8957c3ce08c0c2b6d8d5c995b66f05"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"zopfli"
    system bin"zopflipng", test_fixtures("test.png"), "#{testpath}out.png"
    assert_path_exists testpath"out.png"
  end
end