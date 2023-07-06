class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.114",
      revision: "ed1bb7edb7f244a2711b9c36a52efaff1b025fc4"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c71566340614ed9189d043e4c0c7d4a8926a73c221fd2be07076da42a785ab53"
    sha256 cellar: :any,                 arm64_monterey: "0e4c7956d9bf90229c68b69c69f1f543cced3cce28fe4bbde7df927c295c51c2"
    sha256 cellar: :any,                 arm64_big_sur:  "890af328f0bd793276387264d4c30366cfa2163820e9a367c0f0122ca6e371dd"
    sha256 cellar: :any,                 ventura:        "f86590a8cc8029de53b19f2c6390a44d2599e9befa56de654752fc8e7f2ffd55"
    sha256 cellar: :any,                 monterey:       "afda2cc47bb40a9f336289416378609210b5e1f5d725aaabde08b2c0dcbccc6e"
    sha256 cellar: :any,                 big_sur:        "f901bd7065e22ec111c443abce409fa8ab8f3bba0036ff8c8426e52d5d1134da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee04225d6ccd376812f1a53899b2c97392ffa734b51d8d2c18e8e7c4c25b2cba"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end