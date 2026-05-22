class QuickjsNg < Formula
  desc "QuickJS, the Next Generation: a mighty JavaScript engine"
  homepage "https://quickjs-ng.github.io/quickjs/"
  url "https://ghfast.top/https://github.com/quickjs-ng/quickjs/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "d65f951fa9d347a912a53ec2c151bd0ac79bf73d445788e67670ca1b894c67c4"
  license "MIT"
  head "https://github.com/quickjs-ng/quickjs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d0326e987b2597ce42a18e90865672e4df9cf019651bc379cabe4da0bf78aec"
    sha256 cellar: :any,                 arm64_sequoia: "082b95deeb080c8d31cc153f13ec864f3dc64e1c090fc6eb0241df4ffb280942"
    sha256 cellar: :any,                 arm64_sonoma:  "aafbd22aef82c3f5695e8657f8376e2ca3c1ae9eb399211796e165a249d0dc05"
    sha256 cellar: :any,                 sonoma:        "f9856e0970b849488d657874038eec532ea3f7adae02aa150529254a5edd05f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25514a8a6d60a97c975d599659648188c9ca23d7f91a86bebd0d41be0c30c650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22b9c9023be0f239784dc4259ec89c29096356da036f3b7e19be45d47246b73b"
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