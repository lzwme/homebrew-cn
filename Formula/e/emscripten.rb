class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https:emscripten.org"
  # To automate fetching the required resource revisions, you can use this helper script:
  #   https:gist.github.comcarlocab2db1d7245fa0cd3e92e01fe37b164021
  url "https:github.comemscripten-coreemscriptenarchiverefstags4.0.0.tar.gz"
  sha256 "43c4bba08c6e9d588c0d8f580f54026eb5487e3d7aeec6ec6c755af347dc9bab"
  license all_of: [
    "Apache-2.0", # binaryen
    "Apache-2.0" => { with: "LLVM-exception" }, # llvm
    any_of: ["MIT", "NCSA"], # emscripten
  ]
  head "https:github.comemscripten-coreemscripten.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9c4a520f9c0897a553a460d2e7e46fd9bb1af3ef7251dba3723ec038f2c5723"
    sha256 cellar: :any,                 arm64_sonoma:  "dc1b56ee3857f300d73a229276f849c45e8cca915d1d2a65e62fc7ac596849fd"
    sha256 cellar: :any,                 arm64_ventura: "e90a692acabff2726d9513179fada35b3ca79c6f70bf1b3ade29f37aa972d412"
    sha256 cellar: :any,                 sonoma:        "9df59a0e4e166176270ce8d0b7d3bf722d249ab7c7fce6840067a579ee3d6cea"
    sha256 cellar: :any,                 ventura:       "4ece0c806be2a4bea27421f56bbd8394bdff507085735bcdd8ba1282043f00c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0efbe2a36295cb39ed69ef36cedff31e56f44667b65daba22cfab8f76376b6f0"
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@3.13"
  depends_on "yuicompressor"

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  # OpenJDK is needed as a dependency on Linux and ARM64 for google-closure-compiler,
  # an emscripten dependency, because the native GraalVM image will not work.
  on_macos do
    on_arm do
      depends_on "openjdk"
    end
  end

  on_linux do
    depends_on "openjdk"
  end

  # We use LLVM to work around an error while building bundled `google-benchmark` with GCC
  fails_with :gcc do
    cause <<~EOS
      ...third-partybenchmarksrcthread_manager.h:50:31: error: expected ‘)’ before ‘(’ token
         50 |   GUARDED_BY(GetBenchmarkMutex()) Result results;
            |                               ^
    EOS
  end

  # Use emscripten's recommended binaryen revision to avoid build failures.
  # https:github.comemscripten-coreemscriptenissues12252
  # To find the correct binaryen revision, find the corresponding version commit at:
  # https:github.comemscripten-coreemsdkblobmainemscripten-releases-tags.json
  # Then take this commit and go to:
  # https:chromium.googlesource.comemscripten-releases+<commit>DEPS
  # Then use the listed binaryen_revision for the revision below.
  resource "binaryen" do
    url "https:github.comWebAssemblybinaryen.git",
        revision: "63be8c0fe9ae9a63c91f5bf3b0f8d6c2446620b2"
  end

  # emscripten does not support using the stable version of LLVM.
  # https:github.comemscripten-coreemscriptenissues11362
  # See binaryen resource above for instructions on how to update this.
  # Then use the listed llvm_project_revision for the tarball below.
  resource "llvm" do
    url "https:github.comllvmllvm-projectarchive322eb1a92e6d4266184060346616fa0dbe39e731.tar.gz"
    sha256 "528b7a7324343a3241ec211c5fb2c3c0fa56208107969f7deb4e9462bccd25a4"
  end

  def install
    # Avoid hardcoding the executables we pass to `write_env_script` below.
    # Prefer executables without `.py` extensions, but include those with `.py`
    # extensions if there isn't a matching executable without the `.py` extension.
    emscripts = buildpath.children.select do |pn|
      pn.file? && pn.executable? && !(pn.extname == ".py" && pn.basename(".py").exist?)
    end.map(&:basename)

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install buildpath.children

    # Remove unneeded files. See `toolsinstall.py`.
    rm_r(libexec"testthird_party")

    # emscripten needs an llvm build with the following executables:
    # https:github.comemscripten-coreemscriptenblob#{version}docspackaging.md#dependencies
    resource("llvm").stage do
      projects = %w[
        clang
        lld
      ]

      targets = %w[
        host
        WebAssembly
      ]

      # Apple's libstdc++ is too old to build LLVM
      ENV.libcxx if ENV.compiler == :clang

      # See upstream configuration in `srcbuild.py` at
      # https:chromium.googlesource.comemscripten-releases
      args = %W[
        -DLLVM_ENABLE_LIBXML2=OFF
        -DLLVM_INCLUDE_EXAMPLES=OFF
        -DLLVM_LINK_LLVM_DYLIB=OFF
        -DLLVM_BUILD_LLVM_DYLIB=OFF
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
        -DLLVM_ENABLE_BINDINGS=OFF
        -DLLVM_TOOL_LTO_BUILD=OFF
        -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
        -DLLVM_TARGETS_TO_BUILD=#{targets.join(";")}
        -DLLVM_ENABLE_PROJECTS=#{projects.join(";")}
        -DLLVM_ENABLE_TERMINFO=#{!OS.linux?}
        -DCLANG_ENABLE_ARCMT=OFF
        -DCLANG_ENABLE_STATIC_ANALYZER=OFF
        -DLLVM_INCLUDE_TESTS=OFF
        -DLLVM_INSTALL_UTILS=OFF
        -DLLVM_ENABLE_ZSTD=OFF
        -DLLVM_ENABLE_Z3_SOLVER=OFF
      ]
      args << "-DLLVM_ENABLE_LIBEDIT=OFF" if OS.linux?

      system "cmake", "-S", "llvm", "-B", "build",
                      "-G", "Unix Makefiles",
                      *args, *std_cmake_args(install_prefix: libexec"llvm")
      system "cmake", "--build", "build"
      system "cmake", "--build", "build", "--target", "install"

      # Remove unneeded tools. Taken from upstream `srcbuild.py`.
      unneeded = %w[
        check cl cpp extef-mapping format func-mapping import-test offload-bundler refactor rename scan-deps
      ].map { |suffix| "clang-#{suffix}" }
      unneeded += %w[lld-link ld.lld ld64.lld llvm-lib ld64.lld.darwinnew ld64.lld.darwinold]
      (libexec"llvmbin").glob("{#{unneeded.join(",")}}").map(&:unlink)
      (libexec"llvmlib").glob("libclang.{dylib,so.*}").map(&:unlink)

      # Include needed tools omitted by `LLVM_INSTALL_TOOLCHAIN_ONLY`.
      # Taken from upstream `srcbuild.py`.
      extra_tools = %w[FileCheck llc llvm-as llvm-dis llvm-link llvm-mc
                       llvm-nm llvm-objdump llvm-readobj llvm-size opt
                       llvm-dwarfdump llvm-dwp]
      (libexec"llvmbin").install extra_tools.map { |tool| "buildbin#{tool}" }

      %w[clang clang++].each do |compiler|
        (libexec"llvmbin").install_symlink compiler => "wasm32-#{compiler}"
        (libexec"llvmbin").install_symlink compiler => "wasm32-wasi-#{compiler}"
        bin.install_symlink libexec"llvmbinwasm32-#{compiler}"
        bin.install_symlink libexec"llvmbinwasm32-wasi-#{compiler}"
      end
    end

    resource("binaryen").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec"binaryen")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    cd libexec do
      system "npm", "install", *std_npm_args(prefix: false)
      # Delete native GraalVM image in incompatible platforms.
      if OS.linux?
        rm_r("node_modulesgoogle-closure-compiler-linux")
      elsif Hardware::CPU.arm?
        rm_r("node_modulesgoogle-closure-compiler-osx")
      end
    end

    # Add JAVA_HOME to env_script on ARM64 macOS and Linux, so that google-closure-compiler
    # can find OpenJDK
    emscript_env = { PYTHON: Formula["python@3.13"].opt_bin"python3.13" }
    emscript_env.merge! Language::Java.overridable_java_home_env if OS.linux? || Hardware::CPU.arm?

    emscripts.each do |emscript|
      (binemscript).write_env_script libexecemscript, emscript_env
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec"node_modulesfseventsfsevents.node"
  end

  def post_install
    return if File.exist?("#{Dir.home}.emscripten")
    return if (libexec".emscripten").exist?

    system bin"emcc", "--generate-config"
    inreplace libexec".emscripten" do |s|
      s.change_make_var! "LLVM_ROOT", "'#{libexec}llvmbin'"
      s.change_make_var! "BINARYEN_ROOT", "'#{libexec}binaryen'"
      s.change_make_var! "NODE_JS", "'#{Formula["node"].opt_bin}node'"
    end
  end

  def caveats
    return unless File.exist?("#{Dir.home}.emscripten")
    return if (libexec".emscripten").exist?

    <<~EOS
      You have a ~.emscripten configuration file, so the default configuration
      file was not generated. To generate the default configuration:
        rm ~.emscripten
        brew postinstall emscripten
    EOS
  end

  test do
    ENV["EM_CACHE"] = testpath

    # We're targeting WASM, so we don't want to use the macOS SDK here.
    ENV.remove_macosxsdk if OS.mac?
    # Avoid errors on Linux when other formulae like `sdl12-compat` are installed
    ENV.delete "CPATH"

    (testpath"test.c").write <<~C
      #include <stdio.h>
      int main()
      {
        printf("Hello World!");
        return 0;
      }
    C

    system bin"emcc", "test.c", "-o", "test.js", "-s", "NO_EXIT_RUNTIME=0"
    assert_equal "Hello World!", shell_output("node test.js").chomp
  end
end