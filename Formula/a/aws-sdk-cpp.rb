class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https:github.comawsaws-sdk-cpp.git",
      tag:      "1.11.235",
      revision: "fdce53507c1d57d938d8bc0c1ea62fd6fd06433b"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36f6e91bfec1963664868b9e5fea9d8e97f9563cf794bd541632698d81fd53f8"
    sha256 cellar: :any,                 arm64_ventura:  "3d787c83005654557cb62cb5559040e7430fd01b03076cbacd64eccafacd9007"
    sha256 cellar: :any,                 arm64_monterey: "d084f9805b825b09eba166aa2179c5f0edb7144fb4bbfe9f56c8c3a044b0a22e"
    sha256 cellar: :any,                 sonoma:         "8315c7675a9a451ee462d972aca25a26ade6d5bffe0995fef938cf8c86686281"
    sha256 cellar: :any,                 ventura:        "09af2adacaeaaae6876d5361b85601bee297494e5dd3de2b00fec42d049bd991"
    sha256 cellar: :any,                 monterey:       "0fb893836552bfa166f9e3a79f382ea6593877b2ec9522a645db897aed33e839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4e408ec28ad6a4a446e741e897b79c5ada34ea34cd8b4097851c4d4a28dbb9"
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

    lib.install Dir[lib"macRelease*"].select { |f| File.file? f }
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <awscoreVersion.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system ".test"
  end
end