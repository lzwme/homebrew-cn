class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https:github.comc3langc3c"
  url "https:github.comc3langc3carchiverefstagsv0.6.2.tar.gz"
  sha256 "e39f98d5a78f9d3aa8da4ce07062b4ca93d25b88107961cbd3af2b3f6bcf8e78"
  license "LGPL-3.0-only"
  revision 1
  head "https:github.comc3langc3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6fceff3b368580212fb57c1c31daebf31d53f7555b16d16b8a5822ed9847311b"
    sha256 cellar: :any,                 arm64_sonoma:  "57a190baa5a539f891b28fa56d7dccb0bd6169b6d9e819c0bb1467913511348d"
    sha256 cellar: :any,                 arm64_ventura: "f30e7fb7d4e2b89579730d76d23bc815242115d8e805127565602a75597d46aa"
    sha256 cellar: :any,                 sonoma:        "6b509cd22bdbee60382b5e430e7e2961c7ac18dd4eb228667cd753122fd146f9"
    sha256 cellar: :any,                 ventura:       "efc433ad4eefc49ad65ccbf8b544cd51efc156ebad455c2f30feaf3493ded940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35aa7fa878153939fbfb9bbdcb517efced0c22b7488a52d6b0cf00b8072de953"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm"
  end

  def install
    # Link dynamically to our libLLVM. We can't do the same for liblld*,
    # since we only ship static libraries.
    inreplace "CMakeLists.txt" do |s|
      s.gsub!("libLLVM.so", "libLLVM.dylib") if OS.mac?
      s.gsub!((liblld[A-Za-z]+)\.so, "\\1.a")
    end

    ENV.append "LDFLAGS", "-lzstd -lz" if OS.mac?
    system "cmake", "-S", ".", "-B", "build",
                    "-DC3_LINK_DYNAMIC=#{OS.mac? ? "ON" : "OFF"}", # FIXME: dynamic linking fails the Linux build.
                    "-DC3_USE_MIMALLOC=OFF",
                    "-DC3_USE_TB=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # The build copies LLVM runtime libraries into its `bin` directory.
    # Let's replace those copies with a symlink instead.
    libexec.install bin.children
    bin.install_symlink libexec.children.select { |child| child.file? && child.executable? }
    rm_r libexec"c3c_rt"
    llvm = Formula["llvm"]
    libexec.install_symlink llvm.opt_lib"clang"llvm.version.major"libdarwin" => "c3c_rt"
  end

  test do
    (testpath"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}test")
  end
end