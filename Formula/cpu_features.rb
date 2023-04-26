class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://ghproxy.com/https://github.com/google/cpu_features/archive/v0.8.0.tar.gz"
  sha256 "a3fc6a08ebbf40c538456d6a20ab294658bcebc8d0918457f33cb86f868f16a2"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 ventura:      "3d0b76dd735062c63f550d28658db54bac4b5700b38a7d432af4d06e643689d9"
    sha256 cellar: :any,                 monterey:     "3bb8f83f19934b38463ae275d3a58757066c22aeccc169a4a90f89f62f183445"
    sha256 cellar: :any,                 big_sur:      "c1bc7b3f3cd4801eb81bd8e7068745138955590f5e723497db0465cad2dae3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "745b3609cd2162a24347cbee203145727b1bdcc7301b4243c7a4f6ecf037c2f6"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on arch: :x86_64 # https://github.com/google/cpu_features#whats-supported
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install static lib too
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libcpu_features.a"
  end

  test do
    output = shell_output(bin/"list_cpu_features")
    assert_match(/^arch\s*:/, output)
    assert_match(/^brand\s*:/, output)
    assert_match(/^family\s*:/, output)
    assert_match(/^model\s*:/, output)
    assert_match(/^stepping\s*:/, output)
    assert_match(/^uarch\s*:/, output)
    assert_match(/^flags\s*:/, output)
  end
end