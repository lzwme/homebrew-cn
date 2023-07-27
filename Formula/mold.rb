class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://ghproxy.com/https://github.com/rui314/mold/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "2ae8a22db09cbff626df74c945079fa29c1e5f60bbe02502dcf69191cf43527b"
  license "MIT"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b5d5c32ac041c6d535d803477ae5859794808333d2147b0017126c04b41f5e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7159047337e6a1152241321ea9b7490597a852fced4200dac71ef30e48e0ff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef08b475f6507cd6cda8c0795a46271d7e71c24c4ce883f02a5505cde915a61e"
    sha256 cellar: :any_skip_relocation, ventura:        "a32a6251a8f319d2c35f7b5ce784d9a5375af24646c60e8d6d7c5b8016ce805e"
    sha256 cellar: :any_skip_relocation, monterey:       "3e08b8b4fe6c16538fa0cb083d722f2c89b321748407db5a55d778f902ab3b68"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd02ea90a0432a4ecb1762b63cf8ad094a0534898c2d74c886c17fe1419c0bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "520d831c82593d5e8359e75ffb7d3043f3d58ffcc903ea711e1ab62ad59ee0b5"
  end

  depends_on "cmake" => :build
  depends_on "tbb"
  depends_on "zstd"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "mimalloc"
    depends_on "openssl@3" # Uses CommonCrypto on macOS
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
    inreplace "common/config.h.in", "@CMAKE_INSTALL_FULL_LIBDIR@", ""
    # Ensure we're using Homebrew-provided versions of these dependencies.
    %w[mimalloc tbb zlib zstd].map { |dir| (buildpath/"third-party"/dir).rmtree }
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
      See https://github.com/bluewhalesystems/sold for macOS/iOS support.
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main(void) { return 0; }
    EOS

    linker_flag = case ENV.compiler
    when /^gcc(-(\d|10|11))?$/ then "-B#{libexec}/mold"
    when :clang, /^gcc-\d{2,}$/ then "-fuse-ld=mold"
    else odie "unexpected compiler"
    end

    extra_flags = %w[-fPIE -pie]
    extra_flags += %w[--target=x86_64-unknown-linux-gnu -nostdlib] unless OS.linux?

    system ENV.cc, linker_flag, *extra_flags, "test.c"
    if OS.linux?
      system "./a.out"
    else
      assert_match "ELF 64-bit LSB pie executable, x86-64", shell_output("file a.out")
    end

    return unless OS.linux?

    cp_r pkgshare/"test", testpath

    # Remove non-native tests.
    arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch.to_s
    testpath.glob("test/elf/*.sh")
            .reject { |f| f.basename(".sh").to_s.match?(/^(#{arch}_)?[^_]+$/) }
            .each(&:unlink)

    inreplace testpath.glob("test/elf/*.sh") do |s|
      s.gsub!(%r{(\./|`pwd`/)?mold-wrapper}, lib/"mold/mold-wrapper", false)
      s.gsub!(%r{(\.|`pwd`)/mold}, bin/"mold", false)
      s.gsub!(/-B(\.|`pwd`)/, "-B#{libexec}/mold", false)
    end

    # The `inreplace` rules above do not work well on this test. To avoid adding
    # too much complexity to the regex rules, it is manually tested below
    # instead.
    (testpath/"test/elf/mold-wrapper2.sh").unlink
    assert_match "mold-wrapper.so",
      shell_output("#{bin}/mold -run bash -c 'echo $LD_PRELOAD'")

    # Run the remaining tests.
    testpath.glob("test/elf/*.sh").each { |t| system "bash", t }
  end
end