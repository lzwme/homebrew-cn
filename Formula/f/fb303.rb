class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2025.06.23.00.tar.gz"
  sha256 "664e2d74f1b3d9cd2251e705f66d55c6779337fabfeb6e41e109337416bc7ebb"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "142735b438aed14fc1213270955c27a9f72830c0241ac10195fe97f773543502"
    sha256                               arm64_sonoma:  "342d6b8165d443940830f7a75e40a6fd54e70dc29d7765e122f90e013f076104"
    sha256                               arm64_ventura: "a07e4ac46ab83bdde3f8fb62ff5efcde4b63b838e8e510b351fa40f5dcfce11a"
    sha256 cellar: :any,                 sonoma:        "d44a4b37b1d50549892f3c262d974d55bdaac708cc8d52c548e16eda3eb6093c"
    sha256 cellar: :any,                 ventura:       "92b3d305acb4b6825b9fb2bc8e76e1131a934d8def9cc8fa5bf51ae48991c047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c24dbdc0c995c3a1e50df67602de6e67ef832a337068e7b81d5d318e1e55f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b838f78543d728de590c857312f56c3d6bc601bcc773e48a083330e6ed39b0df"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include "fb303thriftgen-cpp2BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    CPP

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-ldl"
    assert_equal "BaseService", shell_output(".test").strip
  end
end