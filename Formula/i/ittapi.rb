class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://ghproxy.com/https://github.com/intel/ittapi/archive/refs/tags/v3.24.3.tar.gz"
  sha256 "cf5903c1bf5c13bc808a04f2d7624eef064f44e76669688f779ebb8d26e9911f"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf7a1ba0db8c9cca9b8e3551c8779aa366880d0c5f359957c2683b2206532aa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1d2bdd9318a540c42ce966cfac7e9006aac07a272b67fdcce74b0a1fefded5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0faf6ee450875406cc84338f4ecdf5cf235dabc7ec5be20d1c5254f505e28424"
    sha256 cellar: :any_skip_relocation, sonoma:         "41b6a5bc9a484df004410d40723a004e73c9bfd06cd1a2d2d2358a47d0c711d1"
    sha256 cellar: :any_skip_relocation, ventura:        "7519c8b4ff62c214077f286d38a9e1d0b6fe12f5d8ad68ba7a7ab6d6e4733331"
    sha256 cellar: :any_skip_relocation, monterey:       "75ce871c785170607043f45c8970e2913ccd66634fdb637a4152d6a71702e85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "990894d4b7b095d391f57eb0dc170f10bd296adb8b13710cddb20af4607028ae"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    system "./test"
  end
end