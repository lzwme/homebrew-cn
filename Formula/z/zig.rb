class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https:ziglang.org"
  url "https:ziglang.orgdownload0.14.0zig-0.14.0.tar.xz"
  sha256 "c76638c03eb204c4432ae092f6fa07c208567e110fbd4d862d131a7332584046"
  license "MIT"
  revision 1

  livecheck do
    url "https:ziglang.orgdownload"
    regex(href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "582c6da9e4c1d916fc318c8d25ee4981941d5c1e89f2e9dac1981173337390b6"
    sha256 cellar: :any,                 arm64_sonoma:  "3ff0ad19dc0d0ed496395844745da89a89d021b7611d28b96fb5f4c208941e9f"
    sha256 cellar: :any,                 arm64_ventura: "b7cadbfbaea540925472f28df0e119c4e26233335cb8886b755ceb1663b5e00a"
    sha256 cellar: :any,                 sonoma:        "1b9125a527782269930c27e0d67a62c3c36656e01906725f080ac972f6bbf3a7"
    sha256 cellar: :any,                 ventura:       "537e3e061b77ad9ca512aa866b9aae06fee5d1e2faa85128cf903aa3d18dc9ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc74fb16422994ef50087b89eee304931acb3568103fc6688176ffc015eeb2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a71266139b1fe7f17638b0ad92b36a424295db899797bcef6fd9a6e64d68d6bc"
  end

  depends_on "cmake" => :build
  depends_on "lld"
  depends_on "llvm"
  depends_on macos: :big_sur # https:github.comziglangzigissues13313

  # NOTE: `z3` should be macOS-only dependency whenever we need to re-add
  on_macos do
    depends_on "z3"
    depends_on "zstd"
  end

  # https:github.comHomebrewhomebrew-coreissues209483
  skip_clean "libziglibcdarwinlibSystem.tbd"

  # Fix linkage with libc++.
  # https:github.comziglangzigpull23264
  patch :DATA

  def install
    llvm = deps.find { |dep| dep.name.match?(^llvm(@\d+)?$) }
               .to_formula
    if llvm.versioned_formula? && deps.any? { |dep| dep.name == "z3" }
      # Don't remove this check even if we're using a versioned LLVM
      # to avoid accidentally keeping it when not needed in the future.
      odie "`z3` dependency should be removed!"
    end

    # Workaround for https:github.comHomebrewhomebrew-corepull141453#discussion_r1320821081.
    # This will likely be fixed upstream by https:github.comziglangzigpull16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    cpu = case Hardware.oldest_cpu # See `zig targets`.
    # Cortex A-53 seems to be the oldest available ARMv8-A processor.
    # https:en.wikipedia.orgwikiARM_Cortex-A53
    when :armv8 then "cortex_a53"
    when :arm_vortex_tempest then "apple_m1"
    else Hardware.oldest_cpu
    end

    args = ["-DZIG_SHARED_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{cpu}" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"hello.zig").write <<~ZIG
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    ZIG
    system bin"zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output(".hello")

    arches = ["aarch64", "x86_64"]
    systems = ["macos", "linux"]
    arches.each do |arch|
      systems.each do |os|
        system bin"zig", "build-exe", "hello.zig", "-target", "#{arch}-#{os}", "--name", "hello-#{arch}-#{os}"
        assert_path_exists testpath"hello-#{arch}-#{os}"
        file_output = shell_output("file --brief hello-#{arch}-#{os}").strip
        if os == "linux"
          assert_match(\bELF\b, file_output)
          assert_match(\b#{arch.tr("_", "-")}\b, file_output)
        else
          assert_match(\bMach-O\b, file_output)
          expected_arch = (arch == "aarch64") ? "arm64" : arch
          assert_match(\b#{expected_arch}\b, file_output)
        end
      end
    end

    native_os = OS.mac? ? "macos" : OS.kernel_name.downcase
    native_arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch
    assert_equal "Hello, world!", shell_output(".hello-#{native_arch}-#{native_os}")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https:github.comziglangzigissues10377
    ENV.delete "CPATH"
    (testpath"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    C
    system bin"zig", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output(".hello-c")

    return unless OS.mac?

    # See https:github.comHomebrewhomebrew-corepull211129
    assert_includes (bin"zig").dynamically_linked_libraries, "usrliblibc++.1.dylib"
  end
end

__END__
From 8f9216e7d10970c21fcda9e8fe6af91a7e0f7db9 Mon Sep 17 00:00:00 2001
From: Michael Dusan <michael.dusan@gmail.com>
Date: Mon, 10 Mar 2025 17:32:00 -0400
Subject: [PATCH] macos stage3: add link support for system libc++

- activates when -DZIG_SHARED_LLVM=ON
- activates when llvm_config is used and --shared-mode is shared
- otherwise vendored libc++ is used

closes #23189
---
 build.zig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git abuild.zig bbuild.zig
index 15762f0ae881..ea729f408f74 100644
--- abuild.zig
+++ bbuild.zig
@@ -782,7 +782,13 @@ fn addCmakeCfgOptionsToExe(
                 mod.linkSystemLibrary("unwind", .{});
             },
             .ios, .macos, .watchos, .tvos, .visionos => {
-                mod.link_libcpp = true;
+                if (static or !std.zig.system.darwin.isSdkInstalled(b.allocator)) {
+                    mod.link_libcpp = true;
+                } else {
+                    const sdk = std.zig.system.darwin.getSdk(b.allocator, b.graph.host.result) orelse return error.SdkDetectFailed;
+                    const @"libc++" = b.pathJoin(&.{ sdk, "usrliblibc++.tbd" });
+                    exe.root_module.addObjectFile(.{ .cwd_relative = @"libc++" });
+                }
             },
             .windows => {
                 if (target.abi != .msvc) mod.link_libcpp = true;