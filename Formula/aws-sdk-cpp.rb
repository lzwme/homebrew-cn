class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.80",
      revision: "8952c2dc964e48105015872aba03a812764130b2"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b63da491902309763771a66333cedcdc5cddae87bfe5e4accab3510fa497c33"
    sha256 cellar: :any,                 arm64_monterey: "71b1909bfa0ac0686f78a1f62729f70dd57927450c375c9dd57570dc4f9cb6e6"
    sha256 cellar: :any,                 arm64_big_sur:  "cf7cba19aabd557794ab644f39b3c2b75372d15d578cfefb5e2612bb527011f8"
    sha256 cellar: :any,                 ventura:        "565ca3f9074bc0e13f88f2bef526899d10d572f0f36fce2f4bac17508e40ea96"
    sha256 cellar: :any,                 monterey:       "886474985bd875a7870cc855c4e71238d1d2aa45a5954f5e0608ceab09203df7"
    sha256 cellar: :any,                 big_sur:        "673d3507c1e8910ea54cdeef6ca0a05738a7ba968ca938b9bf892f6de73bb823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940c8b383a12297f97d32fe451f34194b1b72cdc7e10e1f6d388ae4c30973a49"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end