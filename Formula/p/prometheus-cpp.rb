class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https:github.comjupp0rprometheus-cpp"
  url "https:github.comjupp0rprometheus-cpp.git",
      tag:      "v1.3.0",
      revision: "e5fada43131d251e9c4786b04263ce98b6767ba5"
  license "MIT"
  head "https:github.comjupp0rprometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0469944a3e069184d8a5d5747c8df6c6126912ec2e12e794ec425c768273dfa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "991b7601d5774cef31131ea9cd59e5278962567803bd45841a9425a664d9e1b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6e9b1c1da33cf8f36891e0e628ca217aa85a6c5c657638b243c6fd873221ab5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa88788cb92e0e1396228550dabaf5f8f69fc377eb6e0998035aa02744eb250b"
    sha256 cellar: :any_skip_relocation, ventura:       "306bb5a7cfe366723b2d07ee15a7ee3b05eca2ccda33ae8c7f959d43aed7632c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52dd7c5aeb41b13044d540efe21ac41f3428334a8390f0599bf5b7d4e2dd90b6"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <prometheusregistry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system ".test"
  end
end