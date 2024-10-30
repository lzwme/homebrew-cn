class WasiLibc < Formula
  desc "Libc implementation for WebAssembly"
  homepage "https:wasi.dev"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]
  head "https:github.comWebAssemblywasi-libc.git", branch: "main"

  stable do
    # Check the commit hash of `srcwasi-libc` corresponding to the latest tag at:
    # https:github.comWebAssemblywasi-sdk
    url "https:github.comWebAssemblywasi-libcarchive1b19fc65ad84b223876c50dd4fcd7d5a08c311dc.tar.gz"
    version "24"
    sha256 "a9d5e43c80b5b82fa92325fd73f6f6112ba5631f005030e8d51350efd4c9e61d"

    resource "WASI" do
      # Check the commit hash of `toolswasi-headersWASI` from the commit hash above.
      url "https:github.comWebAssemblyWASIarchive59cbe140561db52fc505555e859de884e0ee7f00.tar.gz"
      sha256 "fc78b28c2c06b64e0233544a65736fc5c515c5520365d6cf821408eadedaf367"
    end
  end

  livecheck do
    url "https:github.comWebAssemblywasi-sdk.git"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baa8c0d028e3691de22e06d6e9958a61898ad0764ffac57441627bb941da6814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baa8c0d028e3691de22e06d6e9958a61898ad0764ffac57441627bb941da6814"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baa8c0d028e3691de22e06d6e9958a61898ad0764ffac57441627bb941da6814"
    sha256 cellar: :any_skip_relocation, sonoma:        "baa8c0d028e3691de22e06d6e9958a61898ad0764ffac57441627bb941da6814"
    sha256 cellar: :any_skip_relocation, ventura:       "baa8c0d028e3691de22e06d6e9958a61898ad0764ffac57441627bb941da6814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32bf0d734a80239892bcaa7c605aea4021e2e45bd2b906231219ab743da488c0"
  end

  depends_on "llvm" => [:build, :test]
  depends_on "lld" => :test
  depends_on "wasmtime" => :test

  # Needs clang
  fails_with :gcc

  def install
    resource("WASI").stage buildpath"toolswasi-headersWASI" if build.stable?

    # We don't want to use superenv here, since we are targeting WASM.
    ENV.remove_cc_etc
    ENV.remove "PATH", Superenv.shims_path

    # Flags taken from Arch:
    # https:gitlab.archlinux.orgarchlinuxpackagingpackageswasi-libc-blobmainPKGBUILD
    make_args = [
      "WASM_CC=#{Formula["llvm"].opt_bin}clang",
      "WASM_AR=#{Formula["llvm"].opt_bin}llvm-ar",
      "WASM_NM=#{Formula["llvm"].opt_bin}llvm-nm",
      "INSTALL_DIR=#{share}wasi-sysroot",
    ]

    # See targets at:
    # https:github.comWebAssemblywasi-sdkblob5e04cd81eb749edb5642537d150ab1ab7aedabe9CMakeLists.txt#L14-L15
    targets = %w[
      wasm32-wasi
      wasm32-wasip1
      wasm32-wasip2
      wasm32-wasip1-threads
      wasm32-wasi-threads
    ]

    # See target flags at:
    # https:github.comWebAssemblywasi-sdkblob5e04cd81eb749edb5642537d150ab1ab7aedabe9cmakewasi-sdk-sysroot.cmake#L117-L135
    target_flags = Hash.new { |h, k| h[k] = [] }
    targets.each { |target| target_flags[target] << "THREAD_MODEL=posix" if target.end_with?("-threads") }
    target_flags["wasm32-wasip2"] << "WASI_SNAPSHOT=p2"

    targets.each do |target|
      system "make", *make_args, "TARGET_TRIPLE=#{target}", "install", *target_flags[target]
      system "make", "clean"
    end
  end

  test do
    # TODO: We should probably build this from source and package it as a formula.
    resource "builtins" do
      url "https:github.comWebAssemblywasi-sdkreleasesdownloadwasi-sdk-24libclang_rt.builtins-wasm32-wasi-24.0.tar.gz"
      sha256 "7e33c0df758b90469b1de3ca158e2d0a7f71934d5884525ba6a372de0b3b0ec7"
    end

    ENV.remove_macosxsdk if OS.mac?
    ENV.remove_cc_etc

    (testpath"test.c").write <<~C
      #include <stdio.h>
      volatile int x = 42;
      int main(void) {
        printf("the answer is %d", x);
        return 0;
      }
    C
    clang = Formula["llvm"].opt_bin"clang"
    clang_resource_dir = Pathname.new(shell_output("#{clang} --print-resource-dir").chomp)
    testpath.install_symlink clang_resource_dir"include"
    resource("builtins").stage testpath"libwasm32-unknown-wasi"
    (testpath"libwasm32-unknown-wasi").install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasi --sysroot=#{share}wasi-sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("wasmtime #{testpath}test")
  end
end