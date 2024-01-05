class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https:github.comKhronosGroupSPIRV-Tools"
  url "https:github.comKhronosGroupSPIRV-Toolsarchiverefstagsvulkan-sdk-1.3.268.0.tar.gz"
  sha256 "4c19fdcffb5fe8ef8dc93d7a65ae78b64edc7a5688893ee381c57f70be77deaf"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comKhronosGroupSPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2968e5bc5bd90543f1962463b6e46748f67fe7f49b3c4a2046ad78ec105cfa48"
    sha256 cellar: :any,                 arm64_ventura:  "1651497b9ad79da1085b704a6d2e1c41bd6bceb0ed44ab3f9271792c895e5ea8"
    sha256 cellar: :any,                 arm64_monterey: "c3c21545f79289d7eb8a3477df3a0c2cc21190d812b88ff1d8220f59e3d1d269"
    sha256 cellar: :any,                 sonoma:         "d46e22452173ceae93d49872aad75d53e0781b78e75274ff978baf2e4913728c"
    sha256 cellar: :any,                 ventura:        "5eaf67999825d921b97c8c4d6ca1dd787977f4447c8902c80586b85291807645"
    sha256 cellar: :any,                 monterey:       "5dea94eeabad98f09a7d092287ca33ac748fedbcaaedc510f45b95977e525978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74849d410bda0d51cf83e4f0432bb906a853f3b84d1f12d2d46bf6c411505fce"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found in .DEPS
    url "https:github.comKhronosGroupSPIRV-Headers.git",
        revision: "1c6bb2743599e6eb6f37b2969acc0aef812e32e3"
  end

  def install
    (buildpath"externalspirv-headers").install resource("spirv-headers")

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV_SKIP_TESTS=ON",
                    "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec"examples").install "examplescpp-interfacemain.cpp"
  end

  test do
    cp libexec"examples""main.cpp", "test.cpp"

    args = if OS.mac?
      ["-lc++"]
    else
      ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system ".test"
  end
end