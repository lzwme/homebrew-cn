class WgpuNative < Formula
  desc "Native WebGPU implementation based on wgpu-core"
  homepage "https://github.com/gfx-rs/wgpu-native"
  url "https://github.com/gfx-rs/wgpu-native.git",
      tag:      "v25.0.2.1",
      revision: "af9074edf144efe4f1432b2e42c477429c4964c1"
  license "Apache-2.0"
  head "https://github.com/gfx-rs/wgpu-native.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb1e0418532763c8a8e38556ba48d263cdee03bfd7b043fd0b2888fe96464738"
    sha256 cellar: :any,                 arm64_sonoma:  "e2815a5fd4d6036b1e494a2474ff1df8c0a4f4df1df7d1ee621c00c4ec03ada7"
    sha256 cellar: :any,                 arm64_ventura: "ac68dc14f145e005d60c7868275d7f952f3f0e4c368cef0eefb8ba887fda82e3"
    sha256 cellar: :any,                 sonoma:        "745b241b6e2dc78e29b547840d03279cd0f603f91fcdf9bdae4182605e526999"
    sha256 cellar: :any,                 ventura:       "3b67dfd8eb82443cbe63d9b76e4928c516534c5c986b96a94a5ec43ffd9a22db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fab225a34edfb5bf5a4307405073098fad497abc3fdb042fb582015dddaf7fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "421381400826ad0f5f8ce03630ef87e37f120cc3b6148b5612374303d025cdf0"
  end

  depends_on "rust" => :build
  depends_on "cmake" => :test
  depends_on "ninja" => :test
  uses_from_macos "llvm" => :build

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s if OS.linux?
    # Not using `cargo install` because wgpu-native doesn't ship binaries
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release", "--locked"

    # Manually install artifacts
    include.install "ffi/webgpu-headers/webgpu.h"
    include.install "ffi/wgpu.h"
    (include/"webgpu-headers").install_symlink "../webgpu.h" => "webgpu.h"

    lib.install "target/release/#{shared_library("libwgpu_native")}"
    lib.install "target/release/libwgpu_native.a"

    # Install examples for sake of testing
    rm_r "examples/vendor"
    inreplace "examples/CMakeLists.txt", "add_subdirectory(vendor/glfw)", ""
    pkgshare.install "examples"
  end

  test do
    system "cmake", "-G", "Ninja",
           "-S", pkgshare/"examples",
           "-B", "build",
           "-DCMAKE_BUILD_TYPE=Release"
    system "cmake", "--build", "build", "--target", "compute"
    # Running the built example fails in CI.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"] && (OS.linux? || Hardware::CPU.intel?)

    cp pkgshare/"examples/compute/shader.wgsl", "."
    assert_match "times: [0, 1, 7, 2]", shell_output("./build/compute/compute")
  end
end