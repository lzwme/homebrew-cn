class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://ghfast.top/https://github.com/google/re2/archive/refs/tags/2025-08-05.tar.gz"
  version "20250805"
  sha256 "b5708d8388110624c85f300e7e9b39c4ed5469891eb1127dd7f9d61272d04907"
  license "BSD-3-Clause"
  head "https://github.com/google/re2.git", branch: "main"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYYMMDD format used in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^(\d{2,4}-\d{2}-\d{2})$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub(/\D/, "") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b5421d604db254fe4039cde9424c3abd4514b4783d86467c4e74af7c2ba4117a"
    sha256 cellar: :any,                 arm64_sonoma:  "406d884451941d575280ccb15bcae0a133f559c85951b8b7a08ab612ae8b5073"
    sha256 cellar: :any,                 arm64_ventura: "7298a931824b58d7324535e6a0ee7cb99d7dbc7c64d1460f34b12a7046ee7982"
    sha256 cellar: :any,                 sonoma:        "6589143978f5da5611e395a974a58c5b0f78dd058b763b64b90840efd819a553"
    sha256 cellar: :any,                 ventura:       "e83b3e1ceeb87c90e3597e192bcf413bf9236b773d00f155a9a11e9fc2f45a84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5202ce3b33fd1f9fd9dbe83edd9dbad057c9e2a3524b1c3c4bde56eb5472f125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5419daca50b9354592231c56cb557ae2588a1d2fbc823000c12967fc8cfcf34"
  end

  depends_on "cmake" => :build
  depends_on "abseil"

  def install
    # Build and install static library
    system "cmake", "-S", ".", "-B", "build-static",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-static"
    system "cmake", "--install", "build-static"

    # Build and install shared library
    system "cmake", "-S", ".", "-B", "build-shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end