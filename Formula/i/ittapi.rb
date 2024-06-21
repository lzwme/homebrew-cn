class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https:github.comintelittapi"
  url "https:github.comintelittapiarchiverefstagsv3.25.0.tar.gz"
  sha256 "0f37bfb6eab7fecadee7936a5f95d833d2afcc32a84e5549ed3f38d614622675"
  license "GPL-2.0-only"
  head "https:github.comintelittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "267c13af12cbaed1b7d42bb9d112370138a27e2f9caede9209d07cff0145abd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb050098ff698f65f85f20327478c92156fa67a4e6d12b4a54eab0836c600aed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53e7435cd45a66452c8283d23d8e9662bcaa9aa18262f91da992a2e4dff1efd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f37a29199dfdbe656b454fa08d956820d92fc166d7b08ae343d8172bc9e669f5"
    sha256 cellar: :any_skip_relocation, ventura:        "95ddb5e9db2f9b586b431fad78adb0c2f4de8b2c16c9b024e2fee1e9a07b5f2d"
    sha256 cellar: :any_skip_relocation, monterey:       "988c8e108b7c5831cf93f3eef95a05637e495b80bf9fadd08957c056c2cb45a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bd5d50525561f031fc2f73f09a1b024ed48d588e81d22c798e5552fcce7b43b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <ittnotify.h>

      __itt_domain* domain = __itt_domain_create("Example.Domain.Global");
      __itt_string_handle* handle_main = __itt_string_handle_create("main");

      int main()
      {
        __itt_task_begin(domain, __itt_null, __itt_null, handle_main);
        __itt_task_end(domain);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-L#{lib}", "-littnotify"
    system ".test"
  end
end