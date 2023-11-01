class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.190",
      revision: "93e1c3782b9fc23e091b27dce1883ed96286e543"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3687bb4c227dfc51fae0116b10d1276a249e041b7acf08fbd21ff42feafa9676"
    sha256 cellar: :any,                 arm64_ventura:  "434730feaed31dbf13d70028edf8bb6d89a9249c1a490f0130a9b9393365fa24"
    sha256 cellar: :any,                 arm64_monterey: "7bafd2ae6193184d12b3b38d38e77c4c316721dd28516fa9823dc4edeff002d0"
    sha256 cellar: :any,                 sonoma:         "a2bc6d18a33cd073a4430655cc39b03f5d07eec373fa143ffffd150ffea714a2"
    sha256 cellar: :any,                 ventura:        "1f4ad44a1439a32b743bf5e9ebe3fe17b7c0ab2e15e680b53d0547778cff418b"
    sha256 cellar: :any,                 monterey:       "58f9d9fc865317d2ee0da2d3d2ddd83e3bfe146de524ba038fe95b2c99a8eb46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "162190ffcd2274befffca5170715fbfcff23b3827924cb254ee732ee32b44728"
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