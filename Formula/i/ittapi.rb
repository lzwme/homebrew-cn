class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https:github.comintelittapi"
  url "https:github.comintelittapiarchiverefstagsv3.25.1.tar.gz"
  sha256 "866a5a75a287a7440760146f99bd1093750c3fb5bf572c3bff2d4795628ebc7c"
  license "GPL-2.0-only"
  head "https:github.comintelittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d4f09136c1fe33da48ef631fb1a4700fe40bd3e813477e3c572eba77ab53682"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1bbac816ffb4199dc86c6c45e3492ddd9505fab2b1edc0ee47c609b6165c02c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2ea835c55aa7878e72f8994b64415e12c139024178a64f415da72c1ab9f037"
    sha256 cellar: :any_skip_relocation, sonoma:         "026b0cddf9895cc025a84a8ac175759583d083a0750857e198bda1c808f4ce12"
    sha256 cellar: :any_skip_relocation, ventura:        "02977edbfae14325f269a32ea5ab16d1ba805483706195ed970aa419e060abc1"
    sha256 cellar: :any_skip_relocation, monterey:       "60e00ba27d32ba1fa46598ef359057369bf13287b4e65214969b842c0c9ea60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "326cd6c3d27e305e8205d85440452ce3d48e74be351605f3ccea601f29d78849"
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