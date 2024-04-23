class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https:ziglang.org"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https:ziglang.orgdownload0.11.0zig-0.11.0.tar.xz"
  sha256 "72014e700e50c0d3528cef3adf80b76b26ab27730133e8202716a187a799e951"
  license "MIT"
  revision 1

  livecheck do
    url "https:ziglang.orgdownload"
    regex(href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "799a1caa052368deb7947441ffe504d8db28fa7b40a8a579d5f2f127fab8216f"
    sha256 cellar: :any,                 arm64_ventura:  "6f6299f3f2c1f62dd1111678a58ad9f9abd790f14c1d02959da823f00d616183"
    sha256 cellar: :any,                 arm64_monterey: "cf459782bb991b79c8f30424d63f7d7352d8659756c53c3c0881c7fd20f83198"
    sha256 cellar: :any,                 sonoma:         "3cd6b970924d7cae4ef2ceb73a3e8572d63ccc96bc8ae8d4b1b6144adcfd9781"
    sha256 cellar: :any,                 ventura:        "b2ee0ec4088368929a0f36bf40e11a0f5194373abc2c7b763b4f5a75ac9f59cf"
    sha256 cellar: :any,                 monterey:       "77d35330e2f4699df927993d1d65be6cc3e5d8d89149da1246c14909cca1e2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b639b67b1112dff3e10e3e34057ea946d5e72ed246ca74a526d0aeaf786040"
  end

  depends_on "cmake" => :build
  # Check: https:github.comziglangzigblob#{version}CMakeLists.txt
  # for supported LLVM version.
  # When switching to `llvm`, remove the `on_linux` block below.
  depends_on "llvm@16" => :build
  depends_on macos: :big_sur # https:github.comziglangzigissues13313
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # `llvm` is not actually used, but we need it because `brew`'s compiler
  # selector does not currently support using Clang from a versioned LLVM.
  on_linux do
    depends_on "llvm" => :build
  end

  fails_with :gcc

  def install
    # Make sure `llvm@16` is used.
    ENV.prepend_path "PATH", Formula["llvm@16"].opt_bin
    ENV["CC"] = Formula["llvm@16"].opt_bin"clang"
    ENV["CXX"] = Formula["llvm@16"].opt_bin"clang++"

    # Work around duplicate symbols with Xcode 15 linker.
    # Remove on next release.
    # https:github.comziglangzigissues17050
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

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
    (testpath"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    system "#{bin}zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output(".hello")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https:github.comziglangzigissues10377
    ENV.delete "CPATH"
    (testpath"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output(".hello")
  end
end