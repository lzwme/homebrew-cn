class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://ghfast.top/https://github.com/ada-url/ada/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "75565e2d4cc8e3ce2dd7927f5c75cc5ebbd3b620468cb0226501dae68d8fe1cd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cf88104b7960250750e0a3513130c8df22987a9b4a450cce0f39496e4f851f54"
    sha256 cellar: :any, arm64_sequoia: "51eaccf2935bb46e41f2b081106330ba357b7786ceb75b9ff5e7fe4b69802157"
    sha256 cellar: :any, arm64_sonoma:  "c52fc920dd88d761c8143b6f6ca9d638de23de98f04815525ba19f01b22f0877"
    sha256 cellar: :any, sonoma:        "5114c8623eb5b23b4ff006aa921a0ced40ba302d9d72311fd4cd1790d97a5830"
  end

  depends_on "cmake" => :build
  depends_on "cxxopts" => :build
  depends_on "fmt"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      ENV.llvm_clang

      # ld: unknown options: --gc-sections
      inreplace "tools/cli/CMakeLists.txt",
                "target_link_options(adaparse PRIVATE \"-Wl,--gc-sections\")",
                ""
    end

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DADA_TOOLS=ON
      -DCPM_USE_LOCAL_PACKAGES=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500
    ENV.prepend_path "PATH", Formula["binutils"].opt_bin if OS.linux?
    # Do not upload a Linux bottle that bypasses audit and needs Linux-only GCC dependency
    ENV.method(DevelopmentTools.default_compiler).call if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.cpp").write <<~CPP
      #include "ada.h"
      #include <iostream>

      int main(int , char *[]) {
        auto url = ada::parse<ada::url_aggregator>("https://www.github.com/ada-url/ada");
        url->set_protocol("http");
        std::cout << url->get_protocol() << std::endl;
        return EXIT_SUCCESS;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20",
           "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output("./test").chomp

    assert_match "search_start 25", shell_output("#{bin}/adaparse -d http://www.google.com/bal?a==11#fddfds")
  end
end