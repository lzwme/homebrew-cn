class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://ghfast.top/https://github.com/intel/ittapi/archive/refs/tags/v3.28.3.tar.gz"
  sha256 "b97bde2b1f4448675955dd93bd132c7eaae2bd98ee8392498f1780caa2d9b849"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c36e4f7278fed8e1c259d6ebe7e163e606b643701abec48fda4c6a16c462c23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5280afa5e733663dd73ff2ef1ec522c6ff2cdc112edf6674b3c941ead052ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "861e299295b5ea4f3a49c63f92daa92b29747772950c00f12a4abe10cd78d037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f168b4f77034b28d023b1d29f04d201dcd35a340480122e85e5c7821951a5b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4022e6678a177a053ffc4693ad92e91153d7b5e1c188f7d9d0e0236f579ae530"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ittnotify.h>

      __itt_domain* domain = __itt_domain_create("Example.Domain.Global");
      __itt_string_handle* handle_main = __itt_string_handle_create("main");

      int main()
      {
        __itt_task_begin(domain, __itt_null, __itt_null, handle_main);
        __itt_task_end(domain);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-L#{lib}", "-littnotify"
    system "./test"
  end
end