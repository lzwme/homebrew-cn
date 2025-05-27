class Mold < Formula
  desc "Modern Linker"
  homepage "https:github.comrui314mold"
  url "https:github.comrui314moldarchiverefstagsv2.40.0.tar.gz"
  sha256 "ee93ef0868cd54d1f30dfba1070dbacf04c1a35428bbea307a4b9242a883ad20"
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
    sha256 cellar: :any,                 arm64_sequoia: "6a3b7de9bbbfb364a531a64be2832a97129435985c6dede2f315eab17e5951ce"
    sha256 cellar: :any,                 arm64_sonoma:  "a651e31a2f57f6064a86070467e4db12fecb379106d4bf5d0f297a788295bcc7"
    sha256 cellar: :any,                 arm64_ventura: "bf6d2d220e4773eaf8b3e9cfeadae57145dda34462c9a10dbe2f1bda7cd3b01f"
    sha256 cellar: :any,                 sonoma:        "ef35ce5f2a6a069ad4b37794241c305bf6d17bb2918b5ad1c59dd68aebe31868"
    sha256 cellar: :any,                 ventura:       "de59aa1cfb6098e23df1cc96e3d62550b39d1a0ffd1ae3c558c82198fa5c1368"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b750229fe4364318e4a7ba0db1fc60089b7df5fcdec75cf97974f8ed86c90f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4edd2600bf10982548f59bf8073afecf049daa14d74c074fedc3ca06516355fc"
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