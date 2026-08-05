class QuickjsNg < Formula
  desc "QuickJS, the Next Generation: a mighty JavaScript engine"
  homepage "https://quickjs-ng.github.io/quickjs/"
  url "https://ghfast.top/https://github.com/quickjs-ng/quickjs/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "4b3c11f37dab2c58bdeccbaeb23b923fa4a9798a45e50be6af55f3e75b616ea0"
  license "MIT"
  head "https://github.com/quickjs-ng/quickjs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ae6d92110ff7db1dcf36f5f26405b50e1b40b9253243185d91e03aada8712712"
    sha256 cellar: :any, arm64_sequoia: "5cb82a0826342e235fefb3fce4ef1ff7ebf47446b93c8dea41d3c008fe934128"
    sha256 cellar: :any, arm64_sonoma:  "1f381046faba2511b0d97290f54655f18be1cda5c1711efb76a792705a320f01"
    sha256 cellar: :any, sonoma:        "40dc9891366a082d8f23f4402915c9cd1ce91b97af001fff8ef9f56581ad8dea"
    sha256 cellar: :any, arm64_linux:   "6bdc475eeb8bf215d693bd0d80b9ad21fd26445d71a2c375a83dd978b93a331c"
    sha256 cellar: :any, x86_64_linux:  "1e4423e1fe84a887fc613fb2830426fe7321fd177d9cbd9e7419d4e3f52f582b"
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