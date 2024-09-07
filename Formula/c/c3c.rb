class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https:github.comc3langc3c"
  url "https:github.comc3langc3carchiverefstagsv0.6.2.tar.gz"
  sha256 "e39f98d5a78f9d3aa8da4ce07062b4ca93d25b88107961cbd3af2b3f6bcf8e78"
  license "LGPL-3.0-only"
  head "https:github.comc3langc3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb180a4f2deaeb13edf804482822f8c5288ef438b23f66c4827de1915dde40df"
    sha256 cellar: :any,                 arm64_ventura:  "93acc32a9a02ebbe234321dd4637646a706070bdee7890d42e6c27b662b5f36f"
    sha256 cellar: :any,                 arm64_monterey: "72557fa0d509682eae2d080bca8805965d13346f4315bd0caa1fdb52ac12fc75"
    sha256 cellar: :any,                 sonoma:         "dfe32cca70fa147b8dc5939f237302293b9193db44508ee4271ca2fe0af9a052"
    sha256 cellar: :any,                 ventura:        "92f0cd5376894a8952ef89d28b2be048f1e558faa258226e6663b07d72b44626"
    sha256 cellar: :any,                 monterey:       "31b0c19166a07d5898b0178c129d2c8a484b127936f62d82ce28fa0a9135c6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5f5d45917d84b6db9d75d00b32473bde36bb4b9d99e6cef363031a77e444394"
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