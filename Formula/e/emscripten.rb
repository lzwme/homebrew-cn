class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  url "https://ghfast.top/https://github.com/emscripten-core/emscripten/archive/refs/tags/6.0.7.tar.gz"
  sha256 "017f199000f433a9e199cf55e6e95e84a713bf2d022c114ce84c66bb67bdcc11"
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
    sha256 cellar: :any, arm64_tahoe:   "692f9ab5df5a26a3feb1a8738e044dffbae4fb93a14d803758cf014fb93ca0bd"
    sha256 cellar: :any, arm64_sequoia: "aac468cf5b610e9ba2b2243afe36705408ddba46ea799a8c1960ce8d7a96cb20"
    sha256 cellar: :any, arm64_sonoma:  "332f04d30d327cc33daee2c40054980179d8a7809821ba3eb42ab233badb8529"
    sha256 cellar: :any, sonoma:        "49cbc336acdb87f722a23da9f7c49ed111768d8d38bdabb86b92661d56b83831"
    sha256 cellar: :any, arm64_linux:   "919792d2c79441e7acf22b47294708dbe79a36a1702205194008686ab0d5e0ea"
    sha256 cellar: :any, x86_64_linux:  "a665eb2e9184da774e917715993badf6488bf69198098d782b879a026031ef27"
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@3.14"
  depends_on "yuicompressor"

  # OpenJDK is needed as a dependency on Linux and ARM64 for google-closure-compiler,
  # an emscripten dependency, because the native GraalVM image will not work.
  on_macos do
    on_arm do
      depends_on "openjdk"
    end
  end

  on_linux do
    depends_on "openjdk"
    depends_on "zlib-ng-compat"
  end

  # Use emscripten's recommended binaryen revision to avoid build failures.
  # https://github.com/emscripten-core/emscripten/issues/12252
  # To find the correct binaryen revision, find the corresponding version commit at:
  # https://github.com/emscripten-core/emsdk/blob/main/emscripten-releases-tags.json
  # Then take this commit and go to:
  # https://chromium.googlesource.com/emscripten-releases/+/<commit>/DEPS
  # Then use the listed binaryen_revision for the revision below.
  resource "binaryen" do
    url "https://ghfast.top/https://github.com/WebAssembly/binaryen/archive/8d9412ef6431ce67f8738554c4d5f091c520b6b7.tar.gz"
    version "8d9412ef6431ce67f8738554c4d5f091c520b6b7"
    sha256 "e14b5afdebdc4d6679bdf3349df2fa91e6608c5e9441bd26d896f253cb37c30c"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/emscripten-core/emsdk/refs/tags/#{LATEST_VERSION}/emscripten-releases-tags.json"
      regex(/["']binaryen_revision["']:\s*["']([0-9a-f]+)["']/i)
      strategy :json do |json, regex|
        # TODO: Find a way to replace `json.dig("aliases", "latest")` with substituted LATEST_VERSION
        release_hash = json.dig("releases", json.dig("aliases", "latest"))
        next if release_hash.blank?

        release_url = "https://chromium.googlesource.com/emscripten-releases/+/#{release_hash}/DEPS?format=TEXT"
        match = Homebrew::Livecheck::Strategy.page_content(release_url)[:content].unpack1("m").match(regex)
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
    url "https://ghfast.top/https://github.com/llvm/llvm-project/archive/4cc02503f584aad493a1d0d35bb5afb710a5510b.tar.gz"
    version "4cc02503f584aad493a1d0d35bb5afb710a5510b"
    sha256 "8654f04c5737882ece1c3ffe415e79c782bba0873de5a1501aeab96a6623e260"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/emscripten-core/emsdk/refs/tags/#{LATEST_VERSION}/emscripten-releases-tags.json"
      regex(/["']llvm_project_revision["']:\s*["']([0-9a-f]+)["']/i)
      strategy :json do |json, regex|
        # TODO: Find a way to replace `json.dig("aliases", "latest")` with substituted LATEST_VERSION
        release_hash = json.dig("releases", json.dig("aliases", "latest"))
        next if release_hash.blank?

        release_url = "https://chromium.googlesource.com/emscripten-releases/+/#{release_hash}/DEPS?format=TEXT"
        match = Homebrew::Livecheck::Strategy.page_content(release_url)[:content].unpack1("m").match(regex)
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
        -DLLVM_INCLUDE_BENCHMARKS=OFF
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
      elsif OS.linux? && Hardware::CPU.arm?
        rm_r("node_modules/google-closure-compiler-linux-arm64")
      elsif OS.mac? && Hardware::CPU.arm?
        rm_r("node_modules/google-closure-compiler-macos")
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

      # Remove musl-libc native variants
      rm_r libexec/"node_modules/lightningcss-#{os}-#{arch}-musl" if OS.linux?
    end

    # Add JAVA_HOME to env_script on ARM64 macOS and Linux, so that google-closure-compiler
    # can find OpenJDK
    emscript_env = { PYTHON: which("python3.14") }
    emscript_env.merge! Language::Java.overridable_java_home_env if OS.linux? || Hardware::CPU.arm?

    emscripts.each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, emscript_env
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"node_modules/fsevents/fsevents.node"

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      set -e
      config="#{opt_libexec}/.emscripten"
      [ -e "$config" ] && exit 0
      if [ -e "$HOME/.emscripten" ]; then
        echo "Skipping configuration generation"
        echo "You have a ~/.emscripten configuration file. Remove it and run brew postinstall emscripten"
        exit 0
      fi
      "#{opt_bin}/emcc" --generate-config
      sed -E -i.bak \
        -e "s|^LLVM_ROOT[[:space:]]*[?+:!]?=.*$|LLVM_ROOT='#{opt_libexec}/llvm/bin'|" \
        -e "s|^BINARYEN_ROOT[[:space:]]*[?+:!]?=.*$|BINARYEN_ROOT='#{opt_libexec}/binaryen'|" \
        -e "s|^NODE_JS[[:space:]]*[?+:!]?=.*$|NODE_JS='#{formula_opt_bin("node")}/node'|" \
        "$config"
      rm -f "$config.bak"
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    run "post-install", base: :libexec
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