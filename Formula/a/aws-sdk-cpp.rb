class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpp.git",
      tag:      "1.11.405",
      revision: "cc33599af2d81eb1c65a78ae19f8314ddc0cfa38"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f47c49fa29e55ad9feed19a90001bd41bab69baf6b213949cbb98839c004e7de"
    sha256 cellar: :any,                 arm64_sonoma:  "9d91ee4ab934c18a0942584007dc8d6bd647b9dbe1d7fd1d93c988d17913d350"
    sha256 cellar: :any,                 arm64_ventura: "600f6dd6c7ae8d89b71108ed1da44d72cca16d893a75f8292c9936bd125749cb"
    sha256 cellar: :any,                 sonoma:        "8ddbf21d2db50afa9049ddc920ccd2800727821cb5433104081e60b7f8628b8d"
    sha256 cellar: :any,                 ventura:       "403f6707a15c7179ed17db85cdb86467c3e298e7979781b095c84d826994fdcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f9a5090fbfe84629412a104767b5ccd300504b291bab4900c2dce0a2451425"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "s2n", because: "both install s2nunstablecrl.h"

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