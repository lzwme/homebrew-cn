class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https:emscripten.org"
  url "https:github.comemscripten-coreemscriptenarchiverefstags4.0.10.tar.gz"
  sha256 "dc1493ccc207bf6743f9cc97163c4b7671fbd9e22bec9f79fdc000a0edc774fe"
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
    sha256 cellar: :any,                 arm64_sequoia: "1480c2ec79819e33c90031e1ec0f7f0e1e48f0dd64d34133ad8a43198d6ae2e2"
    sha256 cellar: :any,                 arm64_sonoma:  "70c1954dfaea5d449efc76e29a5eb056b2991a207a17ff95196c46ffcf2f2a98"
    sha256 cellar: :any,                 arm64_ventura: "42d26cc7cd7a9a5f3a58b7e4429dc8bc0e07281929b6dd2023608f277751972f"
    sha256 cellar: :any,                 sonoma:        "717d4c091c318c1ec5b51c73117eae924e674a94695c0531521ffcc0750dd8c1"
    sha256 cellar: :any,                 ventura:       "40d90edf001bed2750e8f785e13685255caef296a82a87e67b4b8ff0b84bfc0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f5ac3896162da0803a28d8428a4e9571203e5c1c490556722e7a0a4a2a198c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a1b27194857fb8de8a8945477741f9ad7680bb7df7c17a0d4b2411483a000b"
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
    url "https:github.comWebAssemblybinaryenarchive8c82b6884483315011541e4519afdcb7fd46df68.tar.gz"
    version "8c82b6884483315011541e4519afdcb7fd46df68"
    sha256 "7ab7ffe0dabbefe121ab4234a11d2ab04ff45827df050a0ab8b1cdc66465cbaf"

    livecheck do
      url "https:raw.githubusercontent.comemscripten-coreemsdkrefstags#{LATEST_VERSION}emscripten-releases-tags.json"
      regex(["']binaryen_revision["']:\s*["']([0-9a-f]+)["']i)
      strategy :json do |json, regex|
        # TODO: Find a way to replace `json.dig("aliases", "latest")` with substituted LATEST_VERSION
        release_hash = json.dig("releases", json.dig("aliases", "latest"))
        next if release_hash.blank?

        release_url = "https:chromium.googlesource.comemscripten-releases+#{release_hash}DEPS?format=TEXT"
        match = Base64.decode64(Homebrew::Livecheck::Strategy.page_content(release_url)[:content]).match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  # emscripten does not support using the stable version of LLVM.
  # https:github.comemscripten-coreemscriptenissues11362
  # See binaryen resource above for instructions on how to update this.
  # Then use the listed llvm_project_revision for the tarball below.
  resource "llvm" do
    url "https:github.comllvmllvm-projectarchive8f7e57485ee73205e108d74abb5565d5c63beaca.tar.gz"
    version "8f7e57485ee73205e108d74abb5565d5c63beaca"
    sha256 "ea3bdec770d19962bc678ec290d47feab1c88943acd26837a60caf5285768482"

    livecheck do
      url "https:raw.githubusercontent.comemscripten-coreemsdkrefstags#{LATEST_VERSION}emscripten-releases-tags.json"
      regex(["']llvm_project_revision["']:\s*["']([0-9a-f]+)["']i)
      strategy :json do |json, regex|
        # TODO: Find a way to replace `json.dig("aliases", "latest")` with substituted LATEST_VERSION
        release_hash = json.dig("releases", json.dig("aliases", "latest"))
        next if release_hash.blank?

        release_url = "https:chromium.googlesource.comemscripten-releases+#{release_hash}DEPS?format=TEXT"
        match = Base64.decode64(Homebrew::Livecheck::Strategy.page_content(release_url)[:content]).match(regex)
        next if match.blank?

        match[1]
      end
    end
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
      system "cmake", "-S", ".", "-B", "build",
                      "-DBUILD_TESTS=OFF",
                      *std_cmake_args(install_prefix: libexec"binaryen")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    cd libexec do
      system "npm", "install", *std_npm_args(prefix: false)
      # Delete native GraalVM image in incompatible platforms.
      if OS.linux? && Hardware::CPU.intel?
        rm_r("node_modulesgoogle-closure-compiler-linux")
      elsif OS.mac? && Hardware::CPU.arm?
        rm_r("node_modulesgoogle-closure-compiler-osx")
      end

      # Remove incompatible pre-built binaries
      os = OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
      rollup = libexec"node_modules@rollup"
      platform = OS.linux? ? "#{os}-#{arch}-gnu" : "#{os}-#{arch}"
      permitted_dir = "rollup-#{platform}"
      rollup.glob(rollup"rollup-*").each do |dir|
        next if Dir.glob("#{dir}rollup.*.node").empty?

        rm_r(dir) if permitted_dir != dir.basename.to_s
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