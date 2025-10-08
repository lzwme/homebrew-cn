class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  url "https://ghfast.top/https://github.com/emscripten-core/emscripten/archive/refs/tags/4.0.16.tar.gz"
  sha256 "09c3ca955dfba7d3264e0f23ee35913b4b1fca8765a63d2312038eb86dad4af4"
  license all_of: [
    "Apache-2.0", # binaryen
    "Apache-2.0" => { with: "LLVM-exception" }, # llvm
    any_of: ["MIT", "NCSA"], # emscripten
  ]
  head "https://github.com/emscripten-core/emscripten.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebb647d541380498f412c042a346c4cfb3ae6fb5f80324b7f36881acae2b7381"
    sha256 cellar: :any,                 arm64_sequoia: "ff15a881a5357b4490e855dc4991528ad4a837b4a6ca2d3e4c683fc5554f6cea"
    sha256 cellar: :any,                 arm64_sonoma:  "982f768f1accf1903d38172340d739bc82acff3aaf12645283c0452023213028"
    sha256 cellar: :any,                 sonoma:        "08815366f87e36d90fbb8eb599a1e27ea8e66ca19e8cdcce1b785a9060ea2fa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eb70c4ebd81fffe93a2eff125e60e249171955a65677991f3fe2412321c227c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2955a06124e1fa0273e6a8e756b99fff055538a26cc3b0602b1f8da8558dde57"
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
      .../third-party/benchmark/src/thread_manager.h:50:31: error: expected ‘)’ before ‘(’ token
         50 |   GUARDED_BY(GetBenchmarkMutex()) Result results;
            |                               ^
    EOS
  end

  # Use emscripten's recommended binaryen revision to avoid build failures.
  # https://github.com/emscripten-core/emscripten/issues/12252
  # To find the correct binaryen revision, find the corresponding version commit at:
  # https://github.com/emscripten-core/emsdk/blob/main/emscripten-releases-tags.json
  # Then take this commit and go to:
  # https://chromium.googlesource.com/emscripten-releases/+/<commit>/DEPS
  # Then use the listed binaryen_revision for the revision below.
  resource "binaryen" do
    url "https://ghfast.top/https://github.com/WebAssembly/binaryen/archive/4201437a34698649abe8863270e17aba9d6df8eb.tar.gz"
    version "4201437a34698649abe8863270e17aba9d6df8eb"
    sha256 "6bea2de2dc30332f608cfb6d94eab31871dcedee0a9166f738b148a34440949f"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/emscripten-core/emsdk/refs/tags/#{LATEST_VERSION}/emscripten-releases-tags.json"
      regex(/["']binaryen_revision["']:\s*["']([0-9a-f]+)["']/i)
      strategy :json do |json, regex|
        # TODO: Find a way to replace `json.dig("aliases", "latest")` with substituted LATEST_VERSION
        release_hash = json.dig("releases", json.dig("aliases", "latest"))
        next if release_hash.blank?

        release_url = "https://chromium.googlesource.com/emscripten-releases/+/#{release_hash}/DEPS?format=TEXT"
        match = Base64.decode64(Homebrew::Livecheck::Strategy.page_content(release_url)[:content]).match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  # emscripten does not support using the stable version of LLVM.
  # https://github.com/emscripten-core/emscripten/issues/11362
  # See binaryen resource above for instructions on how to update this.
  # Then use the listed llvm_project_revision for the tarball below.
  resource "llvm" do
    url "https://ghfast.top/https://github.com/llvm/llvm-project/archive/375f48942b9a3f3fbd82133390af25b6c96f1460.tar.gz"
    version "375f48942b9a3f3fbd82133390af25b6c96f1460"
    sha256 "4b874fd3a2abc8115786d90de8ab8e087eec0b23cd7016373cccabc265dc8f70"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/emscripten-core/emsdk/refs/tags/#{LATEST_VERSION}/emscripten-releases-tags.json"
      regex(/["']llvm_project_revision["']:\s*["']([0-9a-f]+)["']/i)
      strategy :json do |json, regex|
        # TODO: Find a way to replace `json.dig("aliases", "latest")` with substituted LATEST_VERSION
        release_hash = json.dig("releases", json.dig("aliases", "latest"))
        next if release_hash.blank?

        release_url = "https://chromium.googlesource.com/emscripten-releases/+/#{release_hash}/DEPS?format=TEXT"
        match = Base64.decode64(Homebrew::Livecheck::Strategy.page_content(release_url)[:content]).match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  def install
    system "tools/maint/create_entry_points.py"

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

    # Remove unneeded files. See `tools/install.py`.
    rm_r(libexec/"test/third_party")

    # emscripten needs an llvm build with the following executables:
    # https://github.com/emscripten-core/emscripten/blob/#{version}/docs/packaging.md#dependencies
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

      # See upstream configuration in `src/build.py` at
      # https://chromium.googlesource.com/emscripten-releases/
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
                      *args, *std_cmake_args(install_prefix: libexec/"llvm")
      system "cmake", "--build", "build"
      system "cmake", "--build", "build", "--target", "install"

      # Remove unneeded tools. Taken from upstream `src/build.py`.
      unneeded = %w[
        check cl cpp extef-mapping format func-mapping import-test offload-bundler refactor rename scan-deps
      ].map { |suffix| "clang-#{suffix}" }
      unneeded += %w[lld-link ld.lld ld64.lld llvm-lib ld64.lld.darwinnew ld64.lld.darwinold]
      (libexec/"llvm/bin").glob("{#{unneeded.join(",")}}").map(&:unlink)
      (libexec/"llvm/lib").glob("libclang.{dylib,so.*}").map(&:unlink)

      # Include needed tools omitted by `LLVM_INSTALL_TOOLCHAIN_ONLY`.
      # Taken from upstream `src/build.py`.
      extra_tools = %w[FileCheck llc llvm-as llvm-dis llvm-link llvm-mc
                       llvm-nm llvm-objdump llvm-readobj llvm-size opt
                       llvm-dwarfdump llvm-dwp]
      (libexec/"llvm/bin").install extra_tools.map { |tool| "build/bin/#{tool}" }

      %w[clang clang++].each do |compiler|
        (libexec/"llvm/bin").install_symlink compiler => "wasm32-#{compiler}"
        (libexec/"llvm/bin").install_symlink compiler => "wasm32-wasi-#{compiler}"
        bin.install_symlink libexec/"llvm/bin/wasm32-#{compiler}"
        bin.install_symlink libexec/"llvm/bin/wasm32-wasi-#{compiler}"
      end
    end

    resource("binaryen").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DBUILD_TESTS=OFF",
                      *std_cmake_args(install_prefix: libexec/"binaryen")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    cd libexec do
      system "npm", "install", *std_npm_args(prefix: false)
      # Delete native GraalVM image in incompatible platforms.
      if OS.linux? && Hardware::CPU.intel?
        rm_r("node_modules/google-closure-compiler-linux")
      elsif OS.mac? && Hardware::CPU.arm?
        rm_r("node_modules/google-closure-compiler-osx")
      end

      # Remove incompatible pre-built binaries
      os = OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
      rollup = libexec/"node_modules/@rollup"
      platform = OS.linux? ? "#{os}-#{arch}-gnu" : "#{os}-#{arch}"
      permitted_dir = "rollup-#{platform}"
      rollup.glob(rollup/"rollup-*").each do |dir|
        next if Dir.glob("#{dir}/rollup.*.node").empty?

        rm_r(dir) if permitted_dir != dir.basename.to_s
      end
    end

    # Add JAVA_HOME to env_script on ARM64 macOS and Linux, so that google-closure-compiler
    # can find OpenJDK
    emscript_env = { PYTHON: Formula["python@3.13"].opt_bin/"python3.13" }
    emscript_env.merge! Language::Java.overridable_java_home_env if OS.linux? || Hardware::CPU.arm?

    emscripts.each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, emscript_env
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"node_modules/fsevents/fsevents.node"
  end

  def post_install
    return if (libexec/".emscripten").exist?

    if File.exist?("#{Dir.home}/.emscripten")
      ohai "Skipping configuration generation"
      puts <<~EOS
        You have a ~/.emscripten configuration file, so the default configuration
        file was not generated. To generate the default configuration:
          rm ~/.emscripten
          brew postinstall emscripten
      EOS
      return
    end

    system bin/"emcc", "--generate-config"
    inreplace libexec/".emscripten" do |s|
      s.change_make_var! "LLVM_ROOT", "'#{libexec}/llvm/bin'"
      s.change_make_var! "BINARYEN_ROOT", "'#{libexec}/binaryen'"
      s.change_make_var! "NODE_JS", "'#{Formula["node"].opt_bin}/node'"
    end
  end

  test do
    ENV["EM_CACHE"] = testpath

    # We're targeting WASM, so we don't want to use the macOS SDK here.
    ENV.remove_macosxsdk if OS.mac?
    # Avoid errors on Linux when other formulae like `sdl12-compat` are installed
    ENV.delete "CPATH"

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main()
      {
        printf("Hello World!");
        return 0;
      }
    C

    system bin/"emcc", "test.c", "-o", "test.js", "-s", "NO_EXIT_RUNTIME=0", "-O2", "-Werror=version-check"
    assert_equal "Hello World!", shell_output("node test.js").chomp
  end
end