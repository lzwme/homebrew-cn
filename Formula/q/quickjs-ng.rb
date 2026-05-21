class QuickjsNg < Formula
  desc "QuickJS, the Next Generation: a mighty JavaScript engine"
  homepage "https://quickjs-ng.github.io/quickjs/"
  url "https://ghfast.top/https://github.com/quickjs-ng/quickjs/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "928e9406addd99eb8623348f2cfcd916eade9a263c60d42be79bc7aee4ee8453"
  license "MIT"
  head "https://github.com/quickjs-ng/quickjs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98e26762e04daa7df0bfeefd040bf4a5dc7577b7f0b70ab828a5469933d6f939"
    sha256 cellar: :any,                 arm64_sequoia: "d5d7d6c5f9d3a8e239ba64dd7407c1eb779f8617026fa597fcb9faf9ca538559"
    sha256 cellar: :any,                 arm64_sonoma:  "708397c7fee74e6be66139d9a9d58a88fc8ebe11547a5e1b5b63a74875cff022"
    sha256 cellar: :any,                 sonoma:        "55c8a19c7caf3f8390b1fe28959b742c32c4061c9d3736b26a25c1aba3fe18bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6351c96a16c15bda44009c7fd2b23dee1e7f91f16a29a25bdcd47ab2d1e4507c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d212e7e31078ffb149ec5116d1736a5fd61f20078114a3baddfa36361d5d0e3"
  end

  depends_on "cmake" => :build

  conflicts_with "quickjs", because: "both install a `qjs` binary"

  def install
    system "cmake", "-S", ".", "-B", "build",
      "-DBUILD_SHARED_LIBS=ON",
      "-DQJS_BUILD_LIBC=ON",
      "-DCMAKE_MACOSX_RPATH=OFF",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'")
    assert_match "QJS42", output

    test_file = testpath/"test.js"
    test_file.write "console.log('hello');"
    system bin/"qjsc", test_file
    assert_path_exists testpath/"out.c"
  end
end