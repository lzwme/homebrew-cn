class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https:ziglang.org"
  url "https:ziglang.orgdownload0.13.0zig-0.13.0.tar.xz"
  sha256 "06c73596beeccb71cc073805bdb9c0e05764128f16478fa53bf17dfabc1d4318"
  license "MIT"
  revision 1

  livecheck do
    url "https:ziglang.orgdownload"
    regex(href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "265d2269f0f6bfef74a37c6b80229475549c21b8772e5c68a43603dfff255824"
    sha256 cellar: :any,                 arm64_sonoma:  "bc7414541dd009f1e35b83931b3f8d566af0d900b42505c4adb4ef4c5a433f50"
    sha256 cellar: :any,                 arm64_ventura: "c03e335f865bd4692f0d7b15c5aae7cc72a24711da05c892550ce0ad30d2faa8"
    sha256 cellar: :any,                 sonoma:        "794a173900285d266245e1079da5bfb3b8edc2523f8931f1bcea3b71a5c3f0c5"
    sha256 cellar: :any,                 ventura:       "675cab707430f952c7a25efec1934e90a1384d1b0a97c59a5ecee86ddd988219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26c173a280a0eb435f921530947eaa81ca87f3a21d0592ecaf42e6fa27dfeeb"
  end

  depends_on "cmake" => :build
  depends_on "llvm@18" => :build
  depends_on macos: :big_sur # https:github.comziglangzigissues13313
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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

    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = ["-DZIG_STATIC_LLVM=ON"]
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
    system bin"zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output(".hello")
  end
end