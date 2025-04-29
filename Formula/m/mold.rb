class Mold < Formula
  desc "Modern Linker"
  homepage "https:github.comrui314mold"
  url "https:github.comrui314moldarchiverefstagsv2.38.1.tar.gz"
  sha256 "14bfb259fd7d0a1fdce9b66f8ed2dd0b134d15019cb359699646afeee1f18118"
  license "MIT"
  head "https:github.comrui314mold.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa31b78fab97dc4b2eb00ed0d982e41bb8f699ec15dec165deae9167267db4e4"
    sha256 cellar: :any,                 arm64_sonoma:  "b5148a1b75ceb0555d574b5577a4e97aa40891ce5e594ad4739cb1a04ab33972"
    sha256 cellar: :any,                 arm64_ventura: "d8578d591f4d1d7957528d9f9bd593b4a049568a7800d1e0c9e698d2dc287394"
    sha256 cellar: :any,                 sonoma:        "020902415eeac40314954d573acf3f660401fe767d09819f0175f32c55e604ef"
    sha256 cellar: :any,                 ventura:       "3456e16b9eda9c4cdb407453730137d7c0870371db5e1cd187fe4ccdfdac9e4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "097163bbc478223fe8ace8c116ccd442d087849dd07ddcd61cc19e05e9b27b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c09636586aabd3d7a658a9352270c17168f117db2d6d3adf676f90f00eccf49"
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

    # remove non-native artifact
    rm "testouttestx86_64reproexe" if OS.linux? && Hardware::CPU.arm?

    pkgshare.install "test"
  end

  def caveats
    <<~EOS
      Support for Mach-O targets has been removed.
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