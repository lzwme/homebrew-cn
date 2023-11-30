class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.210",
      revision: "5584de150bb613052ad71d56c8f47fd3ea3ec75e"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cde7ee1f281f2b86ce2921fbc68cfea7d6d6cd711adf19b7f6b0cb74fae82639"
    sha256 cellar: :any,                 arm64_ventura:  "35112f974d977d64724e6e56475b2a4c1b8161e9cbdcad61fe6e479bf43545f8"
    sha256 cellar: :any,                 arm64_monterey: "06010565599c65fbe4d1a446db1c2e2743a23e5fe75cdf4d712f18daa36df979"
    sha256 cellar: :any,                 sonoma:         "397382c94ee99853d805ab40bf53c5c18c3c9403336d8d829d218060d0541b2f"
    sha256 cellar: :any,                 ventura:        "37d0155407b16097324d86533e08aa6b9960cf94d3d9f76ed0e72e82fa3effeb"
    sha256 cellar: :any,                 monterey:       "bd47e61586d9a42b7c644bd1f6c6d76f6fcdd1faea0f59bcbfb9b2acc99ec091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c503d5943cfbe701b5b480452b494724c19e25d160283fb2d9ac760dc67064"
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