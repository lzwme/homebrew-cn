class Mold < Formula
  desc "Modern Linker"
  homepage "https:github.comrui314mold"
  url "https:github.comrui314moldarchiverefstagsv2.38.0.tar.gz"
  sha256 "c48298c826ba07b99f03f2cb69764bc5b8e9d5531286462554e0d75c21c61e40"
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
    sha256 cellar: :any,                 arm64_sequoia: "f9847fa73cc27a33a9df59e692e18b47bd31e6579c53f89e92a612a39388bc47"
    sha256 cellar: :any,                 arm64_sonoma:  "b34091b83161c08315ac52094fc3993655bc139a24b98622c35f79f4f9c4b819"
    sha256 cellar: :any,                 arm64_ventura: "c4f2d4a23f1f72d8c37b762a64596ebba2cac4088fd03b3219bd9f7d7890760b"
    sha256 cellar: :any,                 sonoma:        "e1c4b42c91d6c41b95b1fd1fb7a6b7335423e1e9a4708f5e67ebb838c6034893"
    sha256 cellar: :any,                 ventura:       "4114c0f6e1cedb92b64779983aa6a017bb355d699fb6d9e58cd5526107d40c7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0316b383045961ee52cf17374d1037c411b379549a012025773b740d4a212b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17815ae5b03c471ce2ac2367019fdc24de8c7b01e3404958a2d3ce5c26753222"
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