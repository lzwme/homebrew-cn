class QuickjsNg < Formula
  desc "QuickJS, the Next Generation: a mighty JavaScript engine"
  homepage "https://quickjs-ng.github.io/quickjs/"
  url "https://ghfast.top/https://github.com/quickjs-ng/quickjs/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "c759423f2ad8f37c8f6af7778dc5324779d5274c1a21f4855e9ad948bbdf0718"
  license "MIT"
  head "https://github.com/quickjs-ng/quickjs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3515e43f9ea17791ad3d3a7ad83a323327db2a7fb7dec0640fd5f092d57def3d"
    sha256 cellar: :any, arm64_sequoia: "d20cc16636b711bce9e896ab26558f9d0cce6162eb07c27c97062691a17d08ca"
    sha256 cellar: :any, arm64_sonoma:  "8a30ce970a068a6629a56738b8cfe81e3ea506b4e4d72ff8e64243541ca6ac34"
    sha256 cellar: :any, sonoma:        "799431fec124d3917926142b5980b8c5197382db822a69ffa199a8fd08a62d41"
    sha256 cellar: :any, arm64_linux:   "3e3b4bc48f05852cc21f75512160b655931e3b1a209940f21a7d82046a4e96b9"
    sha256 cellar: :any, x86_64_linux:  "52ab97239aba43f6181dc3b9b27a55b88394a1c204f17116a7d7f4aebe6cb1bb"
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