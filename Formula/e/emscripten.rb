require "languagenode"

class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https:emscripten.org"
  url "https:github.comemscripten-coreemscriptenarchiverefstags3.1.54.tar.gz"
  sha256 "56a180e8588ebfac9c598d7365bf6c8e89e034497734102767c4e2c9c6a8a7e7"
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
    sha256 cellar: :any,                 arm64_sonoma:   "d610ec5b3fefbd085f3f30da87cfc742e82467ceb19bcc68ad1ddfbbd4c7f5f0"
    sha256 cellar: :any,                 arm64_ventura:  "55d275ce0d8757b2d9d4aa14089b1ea5d488437c9335a641ec4c94677aa5adc8"
    sha256 cellar: :any,                 arm64_monterey: "e68c59077134d71d83b1070f0aa90143e3a2e2658740fd09329f3d08637ca81b"
    sha256 cellar: :any,                 sonoma:         "f7fcb8b47388f5d9afc12ac3eb72688b116ec313bafc6845ccecad80777f00b3"
    sha256 cellar: :any,                 ventura:        "bf8773fcaac91fb3b0aace59e63cda4059aed2c19b9d19e6cc3808cf4a651525"
    sha256 cellar: :any,                 monterey:       "b1ec12ff4c73c4e15f201f60a70462cbf7d569794d93e5321ef35689c2ee09ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54898fadb5fa76917beeddc2491da02eb3bdfed2fd05cf658e8771b7b078ad83"
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@3.12"
  depends_on "yuicompressor"

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

  fails_with gcc: "5"

  # Use emscripten's recommended binaryen revision to avoid build failures.
  # https:github.comemscripten-coreemscriptenissues12252
  # To find the correct binaryen revision, find the corresponding version commit at:
  # https:github.comemscripten-coreemsdkblobmainemscripten-releases-tags.json
  # Then take this commit and go to:
  # https:chromium.googlesource.comemscripten-releases+<commit>DEPS
  # Then use the listed binaryen_revision for the revision below.
  resource "binaryen" do
    url "https:github.comWebAssemblybinaryen.git",
        revision: "feb8f24128c0c3bd53862b2f39acc5116f8ae87e"
  end

  # emscripten does not support using the stable version of LLVM.
  # https:github.comemscripten-coreemscriptenissues11362
  # See binaryen resource above for instructions on how to update this.
  # Then use the listed llvm_project_revision for the tarball below.
  resource "llvm" do
    url "https:github.comllvmllvm-projectarchivee769fb8699e3fa8e40623764f7713bfc783b0330.tar.gz"
    sha256 "3b58a16f3ec7eb9cb510d4d941465ed1ac11b9893435f3c5a3c4a476dc3b94f8"
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
    (libexec"testthird_party").rmtree

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
      system "npm", "install", *Language::Node.local_npm_install_args
      rm_f "node_moduleswsbuilderror.log" # Avoid references to Homebrew shims
      # Delete native GraalVM image in incompatible platforms.
      if OS.linux?
        rm_rf "node_modulesgoogle-closure-compiler-linux"
      elsif Hardware::CPU.arm?
        rm_rf "node_modulesgoogle-closure-compiler-osx"
      end
    end

    # Add JAVA_HOME to env_script on ARM64 macOS and Linux, so that google-closure-compiler
    # can find OpenJDK
    emscript_env = { PYTHON: Formula["python@3.12"].opt_bin"python3.12" }
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
    # We're targeting WASM, so we don't want to use the macOS SDK here.
    ENV.remove_macosxsdk if OS.mac?
    # Avoid errors on Linux when other formulae like `sdl12-compat` are installed
    ENV.delete "CPATH"

    ENV["NODE_OPTIONS"] = "--no-experimental-fetch"

    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Hello World!");
        return 0;
      }
    EOS

    system bin"emcc", "test.c", "-o", "test.js", "-s", "NO_EXIT_RUNTIME=0"
    assert_equal "Hello World!", shell_output("node test.js").chomp
  end
end