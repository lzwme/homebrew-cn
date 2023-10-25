class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.185",
      revision: "713aebfea4705e7437bb0874c47e44ddf13b9b31"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "449d373012e9e9ffb2722052b0f474ebed5292b75eea8c28e65dd4f933996757"
    sha256 cellar: :any,                 arm64_ventura:  "f2e21ad80afbf7d429e3fc49751c218c20a5693ec719e4cf8ac2b302bd381c18"
    sha256 cellar: :any,                 arm64_monterey: "5313aacd548d96125e25ac683c9f42aa1665a734ff37fc15929564bc5816dd8c"
    sha256 cellar: :any,                 sonoma:         "826d54c763dedbaab2c095a2d6900d0c655fdf6279f4ec4dfceef813b1e33842"
    sha256 cellar: :any,                 ventura:        "da45bfa392683e5284013ee9c571e10ba72963adba17777c966f04e7525d053c"
    sha256 cellar: :any,                 monterey:       "afa4e05a18d1b503aa4cbb805612bce832294684ebf18a04ce36d98bacf88a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae03466e8c02330a0cc1e02cac43048c96f7ebba24e05efe79661c1239e308e0"
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