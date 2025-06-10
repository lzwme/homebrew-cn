class Mold < Formula
  desc "Modern Linker"
  homepage "https:github.comrui314mold"
  url "https:github.comrui314moldarchiverefstagsv2.40.1.tar.gz"
  sha256 "d1ce09a69941f8158604c3edcc96c7178231e7dba2da66b20f5ef6e112c443b7"
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
    sha256 cellar: :any,                 arm64_sequoia: "bf323580918e0ce07b0ba3d3eda052f27ddca31a41d13d94d808b5e437a90aa9"
    sha256 cellar: :any,                 arm64_sonoma:  "f5ee2cd50c2f64fefb37f3f37d9e34c17d5d8cb867efcd3297c4e144ed286821"
    sha256 cellar: :any,                 arm64_ventura: "697ad14335e95d226b69b6335da056fa3a4c3d934c9a037f58dcb07eb68d31fc"
    sha256 cellar: :any,                 sonoma:        "e9bba4b8bb463cf8098dcb1d0afd7dc93b208eab742369f3e5892f11a9cf3282"
    sha256 cellar: :any,                 ventura:       "312b38e356e19cabafaf0164a0189832dce9f91a325162cfc485da30b1828624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cac5ebd798b98e8c133fe038cd9b8ea06628532f6003769c0323e5174f856cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda5042f4ab9dcc808166f30ab75356e39aa7bdea0f2ac401bd75ef8151f77d3"
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