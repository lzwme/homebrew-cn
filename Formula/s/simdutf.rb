class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v8.1.0.tar.gz"
  sha256 "64851568d57899f6f8dbc237e184e215ef9f464e6e7ebfb1c5785d19eaddbeb5"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8bafee0245351d11c88f9439d2e17a872ae9c36bef7cbe3130e48f1687efdea1"
    sha256 cellar: :any,                 arm64_sequoia: "6f8a8c871423701346a5203349987c8ecfbec4b0aefa4693135bd1d84745ea4b"
    sha256 cellar: :any,                 arm64_sonoma:  "6f636e1a322ab0bf46b74082485ab33caca0abf0a94e1023538acbca7660d4cf"
    sha256 cellar: :any,                 sonoma:        "cef3b171225c4b6c471830baf8e797709dfda6cdbe129d23e5719820bd365ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faefd84f4b4cc89ffe7b04ce57a5ebf91e8c0849f87848646011b071e9c03c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c00641461c4ecca00b0c5c8204ad62870f25fa76ff565a095ef98d4e2a8a7b61"
  end

  depends_on "aklomp-base64" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78"

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCPM_LOCAL_PACKAGES_ONLY=ON
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "10240", "-I", "100"
  end
end