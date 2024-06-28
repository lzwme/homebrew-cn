class Mold < Formula
  desc "Modern Linker"
  homepage "https:github.comrui314mold"
  url "https:github.comrui314moldarchiverefstagsv2.32.1.tar.gz"
  sha256 "f3c9a527d884c635834fe7d79b3de959b00783bf9446280ea274d996f0335825"
  license "MIT"
  head "https:github.comrui314mold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c83a0ca623d50f77f1952d95209b3d1de01c10f174378ef696158d739e91154e"
    sha256 cellar: :any,                 arm64_ventura:  "0bde23d070fdea6b3bb0ac512f72f90f4f292cf7520e5a800d23093330207f8c"
    sha256 cellar: :any,                 arm64_monterey: "4944dcc793544d6755aee4b5b75c8b3ea149533a270d32e98e515debea2dc0c9"
    sha256 cellar: :any,                 sonoma:         "e7a83542c13701495281d5a28612d2377695c9dc9da54a0b14865cb8d3fc79ca"
    sha256 cellar: :any,                 ventura:        "f36df2eb4ab50c95dcc223a7d68d3da62181bab097dce4fb59fb954ccf2631de"
    sha256 cellar: :any,                 monterey:       "7148de4009e1d5af4682f8918fa29924d26aa5ce20b61579b64ab424962d5577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b2a0a4da4f57b9c9e4840b213f40a90675d397b0cdd74e4bd0c7ab2d806e54a"
  end

  depends_on "cmake" => :build
  depends_on "blake3"
  depends_on "tbb"
  depends_on "zstd"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "mimalloc"
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    # Avoid embedding libdir in the binary.
    # This helps make the bottle relocatable.
    inreplace "commonconfig.h.in", "@CMAKE_INSTALL_FULL_LIBDIR@", ""
    # Ensure we're using Homebrew-provided versions of these dependencies.
    %w[blake3 mimalloc tbb zlib zstd].each { |dir| (buildpath"third-party"dir).rmtree }
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
    (testpath"test.c").write <<~EOS
      int main(void) { return 0; }
    EOS

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
    arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch.to_s
    testpath.glob("testelf*.sh")
            .reject { |f| f.basename(".sh").to_s.match?(^(#{arch}_)?[^_]+$) }
            .each(&:unlink)

    inreplace testpath.glob("testelf*.sh") do |s|
      s.gsub!(%r{(\.|`pwd`)?mold-wrapper}, lib"moldmold-wrapper", false)
      s.gsub!(%r{(\.|`pwd`)mold}, bin"mold", false)
      s.gsub!(-B(\.|`pwd`), "-B#{libexec}mold", false)
    end

    # The `inreplace` rules above do not work well on this test. To avoid adding
    # too much complexity to the regex rules, it is manually tested below
    # instead.
    (testpath"testelfmold-wrapper2.sh").unlink
    assert_match "mold-wrapper.so",
      shell_output("#{bin}mold -run bash -c 'echo $LD_PRELOAD'")

    # Run the remaining tests.
    testpath.glob("testelf*.sh").each { |t| system "bash", t }
  end
end