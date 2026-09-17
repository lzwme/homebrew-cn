class SlintCpp < Formula
  desc "C++ library and headers for the Slint UI toolkit"
  homepage "https://slint.dev/"
  url "https://ghfast.top/https://github.com/slint-ui/slint/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "399ef10a0bcd8db236f755e68548e2e55e7cac00ee3da7f50e8d9d6881d34c25"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d16d02420aebe60621e0a858bad811e77b94ae40f24c496e3c13bca8f8a7afdd"
    sha256 cellar: :any, arm64_tahoe:       "c08bdb1a69bd678f749b7cba965118dab602d9582ba8da15a50a62a84ba58970"
    sha256 cellar: :any, arm64_sequoia:     "b2058603ed90088740f25c1c66f5a5287a23dc21f536d7733494cefc736b771f"
    sha256 cellar: :any, arm64_linux:       "d60eb8aeb77566c2b180cbcda6a1b3e70a8fb2796d02c80be3f7c23f68dcb086"
    sha256 cellar: :any, x86_64_linux:      "a6bff54832c081cbf59629bf26579e0beb7d4eaf1f8bd43dccd2dcd58e80b862"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    # Optimizations recommended by upstream:
    # https://github.com/slint-ui/slint/blob/master/.github/workflows/cpp_package.yaml
    ENV["CARGO_INCREMENTAL"] = "false"
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "fat"
    ENV["CARGO_PROFILE_RELEASE_CODEGEN_UNITS"] = "1"

    extra_cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSLINT_FEATURE_COMPILER=OFF
      -DSLINT_FEATURE_RENDERER_SKIA=ON
      -DSLINT_FEATURE_RENDERER_SKIA_OPENGL=ON
    ]

    extra_cmake_args << "-DSLINT_FEATURE_RENDERER_SKIA_VULKAN=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *extra_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <slint.h>
      int main() {
          return 0;
      }
    CPP

    system ENV.cc, "test.cpp", "-std=c++20", "-I#{include}/slint", "-L#{lib}", "-lslint_cpp", "-o", "test"
    system "./test"
  end
end