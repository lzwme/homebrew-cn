class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://ghfast.top/https://github.com/intel/ittapi/archive/refs/tags/v3.26.5.tar.gz"
  sha256 "9dad3eef9efa749a749f032e35b77b75016a0f1d3e084b89eaad725db44ac01a"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d518f324699dfd3f0c4a77cb626dfcb792807875be47503df6ea2a66724f1f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0225b9f339b427fd90e272be80db224fedde101ac40c577fa9a214f7f76042db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "568282e8e66f1c9bf4a12e7f76010e18b06be1eafd83105fae5176c4df085f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca2c5f32dafe095532f8804321337cb5fdb4ad21885f70ee9307fb65d320f2f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fa80363f3f3ffa8563f7eb550c85e672a1000ce3a8b976f4466eb761c4c6dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab580289b4dc8420b9df3b64ac5cf856c6355bec62df4fc0ca0a963382831a1"
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