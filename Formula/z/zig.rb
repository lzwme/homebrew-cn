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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "17784661a18ed940e5ca7f851d5e625e71c90d16c826e439fa01f8fa834ef241"
    sha256 cellar: :any,                 arm64_sonoma:  "bb7838db2d04fc4b92176a626946e6911f007c76aef67f7d548a5b1f64c1579f"
    sha256 cellar: :any,                 arm64_ventura: "b1e01694ffbde41aa5cb5a1b9854443d4c6e45958884aeb2a27d2f750bbd2e02"
    sha256 cellar: :any,                 sonoma:        "a7bba266b97942083b54ea6c117128b0ccb09d70c58a5b3bb8548c7e60e2889a"
    sha256 cellar: :any,                 ventura:       "ebeb4e27ed049b3df9978a7efd8074a11282f7ce7d2bfa598fb3f9a6821c7480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13ff67f794f962c1d73be3191df29c78f806f7f4b64407ee7c581cc3c94ca37a"
  end

  depends_on "cmake" => :build
  depends_on "llvm@18" => :build
  depends_on macos: :big_sur # https:github.comziglangzigissues13313
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # https:github.comHomebrewhomebrew-coreissues209483
  skip_clean "libziglibcdarwinlibSystem.tbd"

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