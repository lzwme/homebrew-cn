class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.140",
      revision: "7a213348fd59385ad118be3e1054e596a83aa4f4"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01ae84ed70debc161806c2b0706ea6f3086ac109c741b05031f9f8daeeb93807"
    sha256 cellar: :any,                 arm64_monterey: "7fb23975cffadf049ab6d710277ab76778cbdfb1ea4dac7443d834008e646b96"
    sha256 cellar: :any,                 arm64_big_sur:  "18cd16d8b6ce7d62ea378aebe33683451237a3d0f8f1bea83c97c434a53bdf23"
    sha256 cellar: :any,                 ventura:        "c5accd172e54d219cd07af34335fdc46fef6f18e0043b37c757e683da92501f8"
    sha256 cellar: :any,                 monterey:       "02731a8ba4f8273c4b03d7bd78e12a6cfafe9a0e9082d355817bb22e06b1726b"
    sha256 cellar: :any,                 big_sur:        "ab8f6f32094190590f2aeb25551e3993ab1bf51b1eea1c26227776f7555f41bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5712fcfa82a14e3a1c4aeb3d293198b674e60090f3ed01f3423979d5476fb0f5"
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