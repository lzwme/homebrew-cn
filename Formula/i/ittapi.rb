class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https:github.comintelittapi"
  url "https:github.comintelittapiarchiverefstagsv3.24.4.tar.gz"
  sha256 "f7341c563f228f4358b645fce526208c742fe13e61fc3ba2c777ba94d36e98f5"
  license "GPL-2.0-only"
  head "https:github.comintelittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85b1e860b8c33ba0b1cbe5e4f2457e4b067f29d974a8914dedc28b3036f3fb2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b826ca60108bc7007d43d9180a017037e3160b5f0c6aef21a08ed6416f3b42ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "104817cba696e44c83a28eb39b22546f2c48b4f7b26f965caf828ed0e679cafa"
    sha256 cellar: :any_skip_relocation, sonoma:         "2859dcbaee6bfad0d7285e0af16f6cecf7a44687dd4393acb4843fa519ea55b8"
    sha256 cellar: :any_skip_relocation, ventura:        "88036c805a7e29a838653417e34424b0294adbb62fcd87deb2925b6b18fb0a5b"
    sha256 cellar: :any_skip_relocation, monterey:       "528a82a9bd2dba8ff0addd2113cc4756f691769e0f4b6ac55d555cab5e1dc1d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a449da764c421f9a9f269e328d3444eff64b5fa2177d5b8b7291d4198bff63"
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