class WasiLibc < Formula
  desc "Libc implementation for WebAssembly"
  homepage "https://wasi.dev"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]
  head "https://github.com/WebAssembly/wasi-libc.git", branch: "main"

  stable do
    # Check the commit hash of `src/wasi-libc` corresponding to the latest tag at:
    # https://github.com/WebAssembly/wasi-sdk
    url "https://ghfast.top/https://github.com/WebAssembly/wasi-libc/archive/50ae11904df674fecaa311537967fe138c21fcc7.tar.gz"
    version "26"
    sha256 "d5550b25c90ddbede393957849562bdcbc79e9d58ab0ba0bd0763cec965c960a"

    resource "WASI" do
      # Check the commit hash of `tools/wasi-headers/WASI` from the commit hash above.
      url "https://ghfast.top/https://github.com/WebAssembly/WASI/archive/59cbe140561db52fc505555e859de884e0ee7f00.tar.gz"
      sha256 "fc78b28c2c06b64e0233544a65736fc5c515c5520365d6cf821408eadedaf367"
    end
  end

  livecheck do
    url "https://github.com/WebAssembly/wasi-sdk.git"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a754b6e9a71c5f06a2489dea882a36265c186182134db12395124d96288b863b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a754b6e9a71c5f06a2489dea882a36265c186182134db12395124d96288b863b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a754b6e9a71c5f06a2489dea882a36265c186182134db12395124d96288b863b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a754b6e9a71c5f06a2489dea882a36265c186182134db12395124d96288b863b"
    sha256 cellar: :any_skip_relocation, ventura:       "a754b6e9a71c5f06a2489dea882a36265c186182134db12395124d96288b863b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fafccb8cd85eef822881f2ca25d3756a67b09f8176968056c3db83b31019ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fafccb8cd85eef822881f2ca25d3756a67b09f8176968056c3db83b31019ccf"
  end

  depends_on "llvm" => [:build, :test]
  depends_on "lld" => :test
  depends_on "wasmtime" => :test

  # Needs clang
  fails_with :gcc

  def install
    resource("WASI").stage buildpath/"tools/wasi-headers/WASI" if build.stable?

    # We don't want to use superenv here, since we are targeting WASM.
    ENV.remove_cc_etc
    ENV.remove "PATH", Superenv.shims_path

    # Flags taken from Arch:
    # https://gitlab.archlinux.org/archlinux/packaging/packages/wasi-libc/-/blob/main/PKGBUILD
    make_args = [
      "WASM_CC=#{Formula["llvm"].opt_bin}/clang",
      "WASM_AR=#{Formula["llvm"].opt_bin}/llvm-ar",
      "WASM_NM=#{Formula["llvm"].opt_bin}/llvm-nm",
      "INSTALL_DIR=#{share}/wasi-sysroot",
    ]

    # See targets at:
    # https://github.com/WebAssembly/wasi-sdk/blob/5e04cd81eb749edb5642537d150ab1ab7aedabe9/CMakeLists.txt#L14-L15
    targets = %w[
      wasm32-wasi
      wasm32-wasip1
      wasm32-wasip2
      wasm32-wasip1-threads
      wasm32-wasi-threads
    ]

    # See target flags at:
    # https://github.com/WebAssembly/wasi-sdk/blob/5e04cd81eb749edb5642537d150ab1ab7aedabe9/cmake/wasi-sdk-sysroot.cmake#L117-L135
    target_flags = Hash.new { |h, k| h[k] = [] }
    targets.each { |target| target_flags[target] << "THREAD_MODEL=posix" if target.end_with?("-threads") }
    target_flags["wasm32-wasip2"] << "WASI_SNAPSHOT=p2"

    targets.each do |target|
      system "make", *make_args, "TARGET_TRIPLE=#{target}", "install", *target_flags[target]
    end
  end

  test do
    # TODO: We should probably build this from source and package it as a formula.
    resource "builtins" do
      url "https://ghfast.top/https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-24/libclang_rt.builtins-wasm32-wasi-24.0.tar.gz"
      sha256 "7e33c0df758b90469b1de3ca158e2d0a7f71934d5884525ba6a372de0b3b0ec7"
    end

    ENV.remove_macosxsdk if OS.mac?
    ENV.remove_cc_etc

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      volatile int x = 42;
      int main(void) {
        printf("the answer is %d", x);
        return 0;
      }
    C
    clang = Formula["llvm"].opt_bin/"clang"
    clang_resource_dir = Pathname.new(shell_output("#{clang} --print-resource-dir").chomp)
    testpath.install_symlink clang_resource_dir/"include"
    resource("builtins").stage testpath/"lib/wasm32-unknown-wasi"
    (testpath/"lib/wasm32-unknown-wasi").install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasi --sysroot=#{share}/wasi-sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("wasmtime #{testpath}/test")
  end
end