class Mold < Formula
  desc "Modern Linker"
  homepage "https:github.comrui314mold"
  url "https:github.comrui314moldarchiverefstagsv2.35.1.tar.gz"
  sha256 "912b90afe7fde03e53db08d85a62c7b03a57417e54afc72c08e2fa07cab421ff"
  license "MIT"
  head "https:github.comrui314mold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f59f3217206d50393555975638c9667e3459c49779fb2fec2cdef6294f38b4d8"
    sha256 cellar: :any,                 arm64_sonoma:  "0f2ed8d4a6d4028e1b975be258100dd7bd5d21564bb66f39e46b384425a9bc69"
    sha256 cellar: :any,                 arm64_ventura: "393e0d297e7aecf06df3d36ea001dd5d5b8fe94462b6f717afdc0a2ccff2ee66"
    sha256 cellar: :any,                 sonoma:        "85729bf82cd87573df28173c9c90b93d5566f70383db382aa13c4a239d360176"
    sha256 cellar: :any,                 ventura:       "d71f89301d9add1e3a5603d8bd0d03c694abd9c2089a8c592a50a206f3418f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "109be12ec39c94994152396d6ef47faaaa14109b9cf81f817beaa6dd63497173"
  end

  depends_on "cmake" => :build
  depends_on "blake3"
  depends_on "tbb"
  depends_on "zstd"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "mimalloc"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1500)

    # Avoid embedding libdir in the binary.
    # This helps make the bottle relocatable.
    inreplace "libconfig.h.in", "@CMAKE_INSTALL_FULL_LIBDIR@", ""
    # Ensure we're using Homebrew-provided versions of these dependencies.
    %w[blake3 mimalloc tbb zlib zstd].each { |dir| rm_r(buildpath"third-party"dir) }
    args = %w[
      -DMOLD_LTO=ON
      -DMOLD_USE_MIMALLOC=ON
      -DMOLD_USE_SYSTEM_MIMALLOC=ON
      -DMOLD_USE_SYSTEM_TBB=ON
      -DCMAKE_SKIP_INSTALL_RULES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test"
  end

  def caveats
    <<~EOS
      Support for Mach-O targets has been removed.
      See https:github.combluewhalesystemssold for macOSiOS support.
    EOS
  end

  test do
    (testpath"test.c").write <<~C
      int main(void) { return 0; }
    C

    linker_flag = case ENV.compiler
    when ^gcc(-(\d|10|11))?$ then "-B#{libexec}mold"
    when :clang, ^gcc-\d{2,}$ then "-fuse-ld=mold"
    else odie "unexpected compiler"
    end

    extra_flags = %w[-fPIE -pie]
    extra_flags += %w[--target=x86_64-unknown-linux-gnu -nostdlib] unless OS.linux?

    system ENV.cc, linker_flag, *extra_flags, "test.c"
    if OS.linux?
      system ".a.out"
    else
      assert_match "ELF 64-bit LSB pie executable, x86-64", shell_output("file a.out")
    end

    return unless OS.linux?

    cp_r pkgshare"test", testpath

    # Remove non-native tests.
    arch = Hardware::CPU.arch.to_s
    arch = "aarch64" if arch == "arm64"
    testpath.glob("testarch-*.sh")
            .reject { |f| f.basename(".sh").to_s.match?(^arch-#{arch}-) }
            .each(&:unlink)

    inreplace testpath.glob("test*.sh") do |s|
      s.gsub!(%r{(\.|`pwd`)?mold-wrapper}, lib"moldmold-wrapper", audit_result: false)
      s.gsub!(%r{(\.|`pwd`)mold}, bin"mold", audit_result: false)
      s.gsub!(-B(\.|`pwd`), "-B#{libexec}mold", audit_result: false)
    end

    # The `inreplace` rules above do not work well on this test. To avoid adding
    # too much complexity to the regex rules, it is manually tested below
    # instead.
    (testpath"testmold-wrapper2.sh").unlink
    assert_match "mold-wrapper.so",
      shell_output("#{bin}mold -run bash -c 'echo $LD_PRELOAD'")

    # Run the remaining tests.
    testpath.glob("test*.sh").each { |t| system "bash", t }
  end
end