class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https:llvm.org"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.6llvm-project-19.1.6.src.tar.xz"
    sha256 "e3f79317adaa9196d2cfffe1c869d7c100b7540832bc44fe0d3f44a12861fa34"

    # Remove the following patches in LLVM 20.

    # Backport relative `CLANG_CONFIG_FILE_SYSTEM_DIR` patch.
    # https:github.comllvmllvm-projectpull110962
    patch do
      url "https:github.comllvmllvm-projectcommit1682c99a8877364f1d847395cef501e813804caa.patch?full_index=1"
      sha256 "2d0a185e27ff2bc46531fc2c18c61ffab521ae8ece2db5b5bed498a15f3f3758"
    end

    # Support simplified triples in version config files.
    # https:github.comllvmllvm-projectpull111387
    patch do
      url "https:github.comllvmllvm-projectcommit88dd0d33147a7f46a3c9df4aed28ad4e47ef597c.patch?full_index=1"
      sha256 "0acaa80042055ad194306abb9843a94da24f53ee2bb819583d624391a6329b90"
    end
  end

  livecheck do
    url :stable
    regex(^llvmorg[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b81a65c268f7f8b9c223f75e0bdb39146ceea67204bfdafe9ff4453d74f856ac"
    sha256 cellar: :any,                 arm64_sonoma:  "4465517dd63f576de1290997d4836677bf66245055015e3f88bda8c2585c7a5b"
    sha256 cellar: :any,                 arm64_ventura: "8f30b71bc89a334150dd4a6aecc7e88d239bcbe378a3dd81d933e592377b76a0"
    sha256 cellar: :any,                 sonoma:        "ce4938afadc387d9a2a64619ce8ddd33449e0f78c4165d586542c82787208052"
    sha256 cellar: :any,                 ventura:       "bb67bfc15ce74fc161855ddd62e374f5d7010cbd17b85952c723194567896f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6b9e197731234ed6b460ec99c7d1be5c845fbb7cdb9d46dfa2da3fee538b59b"
  end

  keg_only :provided_by_macos

  # https:llvm.orgdocsGettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on "python@3.13"
  depends_on "xz"
  depends_on "z3"
  depends_on "zstd"

  uses_from_macos "libedit"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "binutils" # needed for gold
    depends_on "elfutils" # openmp requires <gelf.h>
  end

  # Fix triple config loading for clang-cl
  # https:github.comllvmllvm-projectpull111397
  patch do
    url "https:github.comllvmllvm-projectcommita3e8b860788934d7cc1489f850f00dcfd9d8b595.patch?full_index=1"
    sha256 "6d8403fec7be55004e94de90b074c2c166811903ad4921fd76274498c5a60a23"
  end

  def python3
    "python3.13"
  end

  def clang_config_file_dir
    etc"clang"
  end

  def install
    # The clang bindings need a little help finding our libclang.
    inreplace "clangbindingspythonclangcindex.py",
              ^(\s*library_path\s*=\s*)None$,
              "\\1'#{lib}'"

    projects = %w[
      clang
      clang-tools-extra
      mlir
      polly
    ]
    runtimes = %w[
      compiler-rt
      libcxx
      libcxxabi
      libunwind
      pstl
    ]

    unless versioned_formula?
      projects << "lldb"

      if OS.mac?
        runtimes << "openmp"
      else
        projects << "openmp"
      end
    end

    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| py.delete_prefix("python@") }
    site_packages = Language::Python.site_packages(python3).delete_prefix("lib")

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    # we install the lldb Python module into libexec to prevent users from
    # accidentally importing it with a non-Homebrew Python or a Homebrew Python
    # in a non-default prefix. See https:lldb.llvm.orgresourcescaveats.html
    args = %W[
      -DLLVM_ENABLE_PROJECTS=#{projects.join(";")}
      -DLLVM_ENABLE_RUNTIMES=#{runtimes.join(";")}
      -DLLVM_POLLY_LINK_INTO_TOOLS=ON
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_LINK_LLVM_DYLIB=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INCLUDE_TESTS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_ENABLE_Z3_SOLVER=#{versioned_formula? ? "OFF" : "ON"}
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DLLVM_USE_RELATIVE_PATHS_IN_FILES=ON
      -DLLVM_SOURCE_PREFIX=.
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_ENABLE_PYTHON=ON
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_ENABLE_LZMA=ON
      -DLLDB_PYTHON_RELATIVE_PATH=libexec#{site_packages}
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DLIBCXX_INSTALL_MODULES=ON
      -DCLANG_PYTHON_BINDINGS_VERSIONS=#{python_versions.join(";")}
      -DLLVM_CREATE_XCODE_TOOLCHAIN=OFF
      -DCLANG_FORCE_MATCHING_LIBCLANG_SOVERSION=OFF
      -DCLANG_CONFIG_FILE_SYSTEM_DIR=#{clang_config_file_dir.relative_path_from(bin)}
      -DCLANG_CONFIG_FILE_USER_DIR=~.configclang
    ]

    if tap.present?
      args += %W[
        -DPACKAGE_VENDOR=#{tap.user}
        -DBUG_REPORT_URL=#{tap.issues_url}
      ]
      args << "-DCLANG_VENDOR_UTI=sh.brew.clang" if tap.official?
    end

    runtimes_cmake_args = []
    builtins_cmake_args = []

    if OS.mac?
      macos_sdk = MacOS.sdk_path_if_needed
      if MacOS.version >= :catalina
        args << "-DFFI_INCLUDE_DIR=#{macos_sdk}usrincludeffi"
        args << "-DFFI_LIBRARY_DIR=#{macos_sdk}usrlib"
      end

      libcxx_install_libdir = lib"c++"
      libunwind_install_libdir = lib"unwind"
      libcxx_rpaths = [loader_path, rpath(source: libcxx_install_libdir, target: libunwind_install_libdir)]

      args << "-DLLVM_BUILD_LLVM_C_DYLIB=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DLIBCXX_PSTL_BACKEND=libdispatch"
      args << "-DLIBCXX_INSTALL_LIBRARY_DIR=#{libcxx_install_libdir}"
      args << "-DLIBUNWIND_INSTALL_LIBRARY_DIR=#{libunwind_install_libdir}"
      args << "-DLIBCXXABI_INSTALL_LIBRARY_DIR=#{libcxx_install_libdir}"
      runtimes_cmake_args << "-DCMAKE_INSTALL_RPATH=#{libcxx_rpaths.join("|")}"

      # Disable builds for OSes not supported by the CLT SDK.
      clt_sdk_support_flags = %w[I WATCH TV].map { |os| "-DCOMPILER_RT_ENABLE_#{os}OS=OFF" }
      builtins_cmake_args += clt_sdk_support_flags
    else
      args << "-DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_include}"
      args << "-DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}"

      # Disable `libxml2` which isn't very useful.
      args << "-DLLVM_ENABLE_LIBXML2=OFF"
      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"
      # Enable llvm gold plugin for LTO
      args << "-DLLVM_BINUTILS_INCDIR=#{Formula["binutils"].opt_include}"
      # Parts of Polly fail to correctly build with PIC when being used for DSOs.
      args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
      runtimes_cmake_args += %w[
        -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON

        -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON
        -DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=OFF
        -DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON
        -DLIBCXX_USE_COMPILER_RT=ON
        -DLIBCXX_HAS_ATOMIC_LIB=OFF

        -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=OFF
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_STATIC_LIBRARY=ON
        -DLIBCXXABI_USE_COMPILER_RT=ON
        -DLIBCXXABI_USE_LLVM_UNWINDER=ON

        -DLIBUNWIND_USE_COMPILER_RT=ON
        -DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON
        -DCOMPILER_RT_USE_LLVM_UNWINDER=ON

        -DSANITIZER_CXX_ABI=libc++
        -DSANITIZER_TEST_CXX=libc++
      ]

      # Prevent compiler-rt from building i386 targets, as this is not portable.
      builtins_cmake_args << "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON"
    end

    # Skip the PGO build on HEAD installs, non-bottle source builds, or versioned formulae.
    # Catalina and earlier requires too many hacks to build with PGO.
    pgo_build = build.stable? && build.bottle? && OS.mac? && (MacOS.version > :catalina) && !versioned_formula?
    lto_build = pgo_build && OS.mac?

    if ENV.cflags.present?
      args << "-DCMAKE_C_FLAGS=#{ENV.cflags}" unless pgo_build
      runtimes_cmake_args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
      builtins_cmake_args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
    end

    if ENV.cxxflags.present?
      args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}" unless pgo_build
      runtimes_cmake_args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
      builtins_cmake_args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
    end

    args << "-DRUNTIMES_CMAKE_ARGS=#{runtimes_cmake_args.join(";")}" if runtimes_cmake_args.present?
    args << "-DBUILTINS_CMAKE_ARGS=#{builtins_cmake_args.join(";")}" if builtins_cmake_args.present?

    llvmpath = buildpath"llvm"
    if pgo_build
      # We build LLVM a few times first for optimisations. See
      # https:github.comHomebrewhomebrew-coreissues77975

      # PGO build adapted from:
      # https:llvm.orgdocsHowToBuildWithPGO.html#building-clang-with-pgo
      # https:github.comllvmllvm-projectblob33ba8bd2llvmutilscollect_and_build_with_pgo.py
      # https:github.comfacebookincubatorBOLTblob01f471e7docsOptimizingClang.md

      # We build the basic parts of a toolchain to profile.
      # The extra targets on macOS are part of a default Compiler-RT build.
      extra_args = [
        "-DLLVM_TARGETS_TO_BUILD=Native#{";AArch64;ARM;X86" if OS.mac?}",
        "-DLLVM_ENABLE_PROJECTS=clang;lld",
        "-DLLVM_ENABLE_RUNTIMES=compiler-rt",
      ]

      # Our stage1 compiler includes the minimum necessary to bootstrap.
      # `llvm-profdata` is needed for profile data pre-processing, and
      # `compiler-rt` to consume profile data.
      stage1_targets = ["clang", "llvm-profdata", "compiler-rt"]
      stage1_targets += if OS.mac?
        extra_args << "-DLLVM_ENABLE_LIBCXX=ON"
        extra_args += clt_sdk_support_flags

        args << "-DLLVM_ENABLE_LTO=Thin" if lto_build
        # LTO creates object files not recognised by Apple libtool.
        args << "-DCMAKE_LIBTOOL=#{llvmpath}stage1binllvm-libtool-darwin"

        # These are needed to enable LTO.
        ["llvm-libtool-darwin", "LTO"]
      else
        # Make sure CMake doesn't try to pass C++-only flags to C compiler.
        extra_args << "-DCMAKE_C_COMPILER=#{ENV.cc}"
        extra_args << "-DCMAKE_CXX_COMPILER=#{ENV.cxx}"

        # We use this as the linker on Linux to control RPATH.
        ["lld"]
      end

      cflags = ENV.cflags&.split || []
      cxxflags = ENV.cxxflags&.split || []
      extra_args << "-DCMAKE_C_FLAGS=#{cflags.join(" ")}" unless cflags.empty?
      extra_args << "-DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}" unless cxxflags.empty?

      # First, build a stage1 compiler. It might be possible to skip this step on macOS
      # and use system Clang instead, but this stage does not take too long, and we want
      # to avoid incompatibilities from generating profile data with a newer Clang than
      # the one we consume the data with.
      mkdir llvmpath"stage1" do
        system "cmake", "-G", "Ninja", "..", *extra_args, *std_cmake_args
        system "cmake", "--build", ".", "--target", *stage1_targets
      end

      # Barring the stage where we generate the profile data, there is no benefit to
      # rebuilding these.
      extra_args << "-DCLANG_TABLEGEN=#{llvmpath}stage1binclang-tblgen"
      extra_args << "-DLLVM_TABLEGEN=#{llvmpath}stage1binllvm-tblgen"

      if OS.linux?
        # Make sure brewed glibc will be used if it is installed.
        linux_library_paths = [
          Formula["glibc"].opt_lib,
          HOMEBREW_PREFIX"lib",
        ]
        linux_linker_flags = linux_library_paths.map { |path| "-L#{path} -Wl,-rpath,#{path}" }
        # Add opt_libs for dependencies to RPATH.
        linux_linker_flags += deps.map(&:to_formula).map { |dep| "-Wl,-rpath,#{dep.opt_lib}" }

        [args, extra_args].each do |arg_array|
          # Add the linker paths to the arguments passed to the temporary compilers and installed toolchain.
          arg_array << "-DCMAKE_EXE_LINKER_FLAGS=#{linux_linker_flags.join(" ")}"
          arg_array << "-DCMAKE_MODULE_LINKER_FLAGS=#{linux_linker_flags.join(" ")}"
          arg_array << "-DCMAKE_SHARED_LINKER_FLAGS=#{linux_linker_flags.join(" ")}"

          # Use stage1 lld instead of ld shim so that we can control RPATH.
          arg_array << "-DLLVM_USE_LINKER=lld"
        end

        # We also need to make sure we can find headers for other formulae on Linux.
        linux_include_paths = [
          HOMEBREW_PREFIX"include",
        ]
        linux_include_paths.each { |path| cxxflags << "-isystem#{path}" }

        # Unset CMAKE_C_COMPILER and CMAKE_CXX_COMPILER so we can set them below.
        extra_args.reject! { |s| s[CMAKE_C(XX)?_COMPILER] }
        extra_args.reject! { |s| s["CMAKE_CXX_FLAGS"] }
        extra_args << "-DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}"
      end

      # Next, build an instrumented stage2 compiler
      mkdir llvmpath"stage2" do
        # LLVM Profile runs out of static counters
        # https:reviews.llvm.orgD92669, https:reviews.llvm.orgD93281
        # Without this, the build produces many warnings of the form
        # LLVM Profile Warning: Unable to track new values: Running out of static counters.
        instrumented_cflags = cflags + %w[-Xclang -mllvm -Xclang -vp-counters-per-site=6]
        instrumented_cxxflags = cxxflags + %w[-Xclang -mllvm -Xclang -vp-counters-per-site=6]
        instrumented_extra_args = extra_args.reject { |s| s[CMAKE_C(XX)?_FLAGS] }

        system "cmake", "-G", "Ninja", "..",
                        "-DCMAKE_C_COMPILER=#{llvmpath}stage1binclang",
                        "-DCMAKE_CXX_COMPILER=#{llvmpath}stage1binclang++",
                        "-DLLVM_BUILD_INSTRUMENTED=IR",
                        "-DLLVM_BUILD_RUNTIME=NO",
                        "-DCMAKE_C_FLAGS=#{instrumented_cflags.join(" ")}",
                        "-DCMAKE_CXX_FLAGS=#{instrumented_cxxflags.join(" ")}",
                        *instrumented_extra_args, *std_cmake_args
        system "cmake", "--build", ".", "--target", "clang", "lld", "runtimes"

        # We run some `check-*` targets to increase profiling
        # coverage. These do not need to succeed.
        # NOTE: If using `Unix Makefiles` generator, `-k 0` needs to replaced with `--keep-going`.
        begin
          system "cmake", "--build", ".", "--target", "check-clang", "check-llvm", "--", "-k", "0"
        rescue BuildError
          nil
        end
      end

      # Then, generate the profile data
      mkdir llvmpath"stage2-profdata" do
        system "cmake", "-G", "Ninja", "..",
                        "-DCMAKE_C_COMPILER=#{llvmpath}stage2binclang",
                        "-DCMAKE_CXX_COMPILER=#{llvmpath}stage2binclang++",
                        "-DLLVM_BUILD_RUNTIMES=OFF",
                        *extra_args.reject { |s| s["TABLEGEN"] },
                        *std_cmake_args

        # This build is for profiling, so it is safe to ignore errors.
        # NOTE: If using `Unix Makefiles` generator, `-k 0` needs to replaced with `--keep-going`.
        begin
          system "cmake", "--build", ".", "--", "-k", "0"
        rescue BuildError
          nil
        end
      end

      # Merge the generated profile data
      profpath = llvmpath"stage2profiles"
      pgo_profile = profpath"pgo_profile.prof"
      system llvmpath"stage1binllvm-profdata", "merge", "-output=#{pgo_profile}", *profpath.glob("*.profraw")

      # Make sure to build with our profiled compiler and use the profile data
      args << "-DCMAKE_C_COMPILER=#{llvmpath}stage1binclang"
      args << "-DCMAKE_CXX_COMPILER=#{llvmpath}stage1binclang++"
      args << "-DLLVM_PROFDATA_FILE=#{pgo_profile}"
      # `llvm-tblgen` is an install target, so let's build that.
      args << "-DCLANG_TABLEGEN=#{llvmpath}stage1binclang-tblgen"

      # Silence some warnings
      cflags << "-Wno-backend-plugin"
      cxxflags << "-Wno-backend-plugin"

      args << "-DCMAKE_C_FLAGS=#{cflags.join(" ")}"
      args << "-DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}"
    end

    # Now, we can build.
    mkdir llvmpath"build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end

    if OS.mac?
      # Get the version from `llvm-config` to get the correct HEAD or RC version too.
      llvm_version = Utils.safe_popen_read(bin"llvm-config", "--version").strip
      soversion = Version.new(llvm_version).major.to_s
      soversion << "git" if llvm_version.end_with?("git")
      if (match = llvm_version.match(-rc\d*$))
        soversion << match[0]
      end

      # Install versioned symlink, or else `llvm-config` doesn't work properly
      lib.install_symlink "libLLVM.dylib" => "libLLVM-#{soversion}.dylib"

      # Install Xcode toolchain. See:
      # https:github.comllvmllvm-projectblobmainllvmtoolsxcode-toolchainCMakeLists.txt
      # We do this manually in order to avoid:
      #   1. installing duplicates of files in the prefix
      #   2. requiring an existing Xcode installation
      xctoolchain = prefix"ToolchainsLLVM#{llvm_version}.xctoolchain"

      system "usrlibexecPlistBuddy", "-c", "Add:CFBundleIdentifier string org.llvm.#{llvm_version}", "Info.plist"
      system "usrlibexecPlistBuddy", "-c", "Add:CompatibilityVersion integer 2", "Info.plist"
      xctoolchain.install "Info.plist"
      (xctoolchain"usr").install_symlink [bin, include, lib, libexec, share]

      # Install a major-versioned symlink that can be used across minorpatch version upgrades.
      xctoolchain.parent.install_symlink xctoolchain.basename.to_s => "LLVM#{soversion}.xctoolchain"

      # Write config files for each macOS major version so that this works across OS upgrades.
      MacOSVersion::SYMBOLS.each_value do |v|
        macos_version = MacOSVersion.new(v)
        write_config_files(macos_version, MacOSVersion.kernel_major_version(macos_version), Hardware::CPU.arch)
      end

      # Also write an unversioned config file as fallback
      write_config_files("", "", Hardware::CPU.arch)
    end

    # Install Vim plugins
    %w[ftdetect ftplugin indent syntax].each do |dir|
      (share"vimvimfiles"dir).install Pathname.glob("*utilsvim#{dir}*.vim")
    end

    # Install Emacs modes
    elisp.install llvmpath.glob("utilsemacs*.el") + share.glob("clang*.el")

    return unless lto_build

    # Convert LTO-generated bitcode in our static archives to MachO. Adapted from Fedora:
    # https:src.fedoraproject.orgrpmsredhat-rpm-configblobrawhidefbrp-llvm-compile-lto-elf
    lib.glob("*.a").each do |static_archive|
      mktemp do
        system bin"llvm-ar", "x", static_archive
        rebuilt_files = []

        Pathname.glob("*.o").each do |bc_file|
          file_type = Utils.safe_popen_read("file", "--brief", bc_file)
          next unless file_type.match?(^LLVM (IR )?bitcode)

          rebuilt_files << bc_file
          system bin"clang", "-fno-lto", "-Wno-unused-command-line-argument",
                              "-x", "ir", bc_file, "-c", "-o", bc_file
        end

        system bin"llvm-ar", "r", static_archive, *rebuilt_files if rebuilt_files.present?
      end
    end
  end

  # We use the extra layer of indirection in `arch` because the FormulaAuditOnSystemConditionals
  # doesn't want to let us use `Hardware::CPU.arch` outside of `install` or `post_install` blocks.
  def write_config_files(macos_version, kernel_version, arch)
    clang_config_file_dir.mkpath

    arches = Set.new([:arm64, :x86_64, :aarch64])
    arches << arch

    sysroot = if macos_version.blank? || (MacOS.version > macos_version && MacOS::CLT.separate_header_package?)
      "#{MacOS::CLT::PKG_PATH}SDKsMacOSX.sdk"
    elsif macos_version >= "10.14"
      "#{MacOS::CLT::PKG_PATH}SDKsMacOSX#{macos_version}.sdk"
    else
      ""
    end

    {
      darwin: kernel_version,
      macosx: macos_version,
    }.each do |system, version|
      arches.each do |target_arch|
        config_file = "#{target_arch}-apple-#{system}#{version}.cfg"
        (clang_config_file_dirconfig_file).atomic_write <<~CONFIG
          -isysroot #{sysroot}
        CONFIG
      end
    end
  end

  def post_install
    return unless OS.mac?

    config_files = {
      darwin: OS.kernel_version.major,
      macosx: MacOS.version,
    }.map do |system, version|
      clang_config_file_dir"#{Hardware::CPU.arch}-apple-#{system}#{version}.cfg"
    end
    return if config_files.all?(&:exist?)

    write_config_files(MacOS.version, OS.kernel_version.major, Hardware::CPU.arch)
  end

  def caveats
    s = <<~EOS
      CLANG_CONFIG_FILE_SYSTEM_DIR: #{clang_config_file_dir}
      CLANG_CONFIG_FILE_USER_DIR:   ~.configclang

      LLD is now provided in a separate formula:
        brew install lld

      We plan to build LLVM 20 with `LLVM_ENABLE_EH=OFF`. Please see:
        https:github.comorgsHomebrewdiscussions5654
    EOS

    on_macos do
      s += <<~EOS

        Using `clang`, `clang++`, etc., requires a CLT installation at `LibraryDeveloperCommandLineTools`.
        If you don't want to install the CLT, you can write appropriate configuration files pointing to your
        SDK at ~.configclang.

        To use the bundled libunwind please use the following LDFLAGS:
          LDFLAGS="-L#{opt_lib}unwind -lunwind"

        To use the bundled libc++ please use the following LDFLAGS:
          LDFLAGS="-L#{opt_lib}c++ -L#{opt_lib}unwind -lunwind"

        NOTE: You probably want to use the libunwind and libc++ provided by macOS unless you know what you're doing.
      EOS
    end

    s
  end

  test do
    alt_location_libs = [
      shared_library("libc++", "*"),
      shared_library("libc++abi", "*"),
      shared_library("libunwind", "*"),
    ]
    assert_empty lib.glob(alt_location_libs) if OS.mac?

    llvm_version = Utils.safe_popen_read(bin"llvm-config", "--version").strip
    llvm_version_major = Version.new(llvm_version).major.to_s
    soversion = llvm_version_major.dup

    if llvm_version.end_with?("git")
      soversion << "git"
    elsif (match = llvm_version.match(-rc\d*$))
      soversion << match[0]
    else
      assert_equal version, llvm_version
    end

    assert_equal prefix.to_s, shell_output("#{bin}llvm-config --prefix").chomp
    assert_equal "-lLLVM-#{soversion}", shell_output("#{bin}llvm-config --libs").chomp
    assert_equal (libshared_library("libLLVM-#{soversion}")).to_s,
                 shell_output("#{bin}llvm-config --libfiles").chomp

    (testpath"test.c").write <<~C
      #include <stdio.h>
      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    C

    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    CPP

    system bin"clang-cpp", "-v", "test.c"
    system bin"clang-cpp", "-v", "test.cpp"

    # Testing default toolchain and SDK location.
    system bin"clang++", "-v",
           "-std=c++11", "test.cpp", "-o", "test++"
    assert_includes MachO::Tools.dylibs("test++"), "usrliblibc++.1.dylib" if OS.mac?
    assert_equal "Hello World!", shell_output(".test++").chomp
    system bin"clang", "-v", "test.c", "-o", "test"
    assert_equal "Hello World!", shell_output(".test").chomp

    # These tests should ignore the usual SDK includes
    with_env(CPATH: nil) do
      # Testing Command Line Tools
      if OS.mac? && MacOS::CLT.installed?
        toolchain_path = "LibraryDeveloperCommandLineTools"
        cpp_base = (MacOS.version >= :big_sur) ? MacOS::CLT.sdk_path : toolchain_path
        system bin"clang++", "-v",
               "--no-default-config",
               "-isysroot", MacOS::CLT.sdk_path,
               "-isystem", "#{cpp_base}usrincludec++v1",
               "-isystem", "#{MacOS::CLT.sdk_path}usrinclude",
               "-isystem", "#{toolchain_path}usrinclude",
               "-std=c++11", "test.cpp", "-o", "testCLT++"
        assert_includes MachO::Tools.dylibs("testCLT++"), "usrliblibc++.1.dylib"
        assert_equal "Hello World!", shell_output(".testCLT++").chomp
        system bin"clang", "-v", "test.c", "-o", "testCLT"
        assert_equal "Hello World!", shell_output(".testCLT").chomp

        targets = ["#{Hardware::CPU.arch}-apple-macosx#{MacOS.full_version}"]

        # The test tends to time out on Intel, so let's do these only for ARM macOS.
        if Hardware::CPU.arm?
          old_macos_version = HOMEBREW_MACOS_OLDEST_SUPPORTED.to_i - 1
          targets << "#{Hardware::CPU.arch}-apple-macosx#{old_macos_version}"

          old_kernel_version = MacOSVersion.kernel_major_version(MacOSVersion.new(old_macos_version.to_s))
          targets << "#{Hardware::CPU.arch}-apple-darwin#{old_kernel_version}"
        end

        targets.each do |target|
          system bin"clang-cpp", "-v", "--target=#{target}", "test.c"
          system bin"clang-cpp", "-v", "--target=#{target}", "test.cpp"

          system bin"clang", "-v", "--target=#{target}", "test.c", "-o", "test-macosx"
          assert_equal "Hello World!", shell_output(".test-macosx").chomp

          system bin"clang++", "-v", "--target=#{target}", "-std=c++11", "test.cpp", "-o", "test++-macosx"
          assert_equal "Hello World!", shell_output(".test++-macosx").chomp
        end
      end

      # Testing Xcode
      if OS.mac? && MacOS::Xcode.installed?
        cpp_base = (MacOS::Xcode.version >= "12.5") ? MacOS::Xcode.sdk_path : MacOS::Xcode.toolchain_path
        system bin"clang++", "-v",
               "--no-default-config",
               "-isysroot", MacOS::Xcode.sdk_path,
               "-isystem", "#{cpp_base}usrincludec++v1",
               "-isystem", "#{MacOS::Xcode.sdk_path}usrinclude",
               "-isystem", "#{MacOS::Xcode.toolchain_path}usrinclude",
               "-std=c++11", "test.cpp", "-o", "testXC++"
        assert_includes MachO::Tools.dylibs("testXC++"), "usrliblibc++.1.dylib"
        assert_equal "Hello World!", shell_output(".testXC++").chomp
        system bin"clang", "-v",
               "-isysroot", MacOS.sdk_path,
               "test.c", "-o", "testXC"
        assert_equal "Hello World!", shell_output(".testXC").chomp
      end

      # link against installed libc++
      # related to https:github.comHomebrewlegacy-homebrewissues47149
      cxx_libdir = OS.mac? ? opt_lib"c++" : opt_lib
      system bin"clang++", "-v",
             "-isystem", "#{opt_include}c++v1",
             "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "testlibc++",
             "-rtlib=compiler-rt", "-L#{cxx_libdir}", "-Wl,-rpath,#{cxx_libdir}"
      assert_includes (testpath"testlibc++").dynamically_linked_libraries,
                      (cxx_libdirshared_library("libc++", "1")).to_s
      (testpath"testlibc++").dynamically_linked_libraries.each do |lib|
        refute_match(libstdc\+\+, lib)
        refute_match(libgcc, lib)
        refute_match(libatomic, lib)
      end
      assert_equal "Hello World!", shell_output(".testlibc++").chomp
    end

    if OS.linux?
      # Link installed libc++, libc++abi, and libunwind archives both into
      # a position independent executable (PIE), as well as into a fully
      # position independent (PIC) DSO for things like plugins that export
      # a C-only API but internally use C++.
      #
      # FIXME: It'd be nice to be able to use flags like `-static-libstdc++`
      # together with `-stdlib=libc++` (the latter one we need anyways for
      # headers) to achieve this but those flags don't set up the correct
      # search paths or handle all of the libraries needed by `libc++` when
      # linking statically.

      system bin"clang++", "-v", "-o", "test_pie_runtimes",
                   "-pie", "-fPIC", "test.cpp", "-L#{opt_lib}",
                   "-stdlib=libc++", "-rtlib=compiler-rt",
                   "-static-libstdc++", "-lpthread", "-ldl"
      assert_equal "Hello World!", shell_output(".test_pie_runtimes").chomp
      (testpath"test_pie_runtimes").dynamically_linked_libraries.each do |lib|
        refute_match(lib(std)?c\+\+, lib)
        refute_match(libgcc, lib)
        refute_match(libatomic, lib)
        refute_match(libunwind, lib)
      end

      (testpath"test_plugin.cpp").write <<~CPP
        #include <iostream>
        __attribute__((visibility("default")))
        extern "C" void run_plugin() {
          std::cout << "Hello Plugin World!" << std::endl;
        }
      CPP
      (testpath"test_plugin_main.c").write <<~C
        extern void run_plugin();
        int main() {
          run_plugin();
        }
      C
      system bin"clang++", "-v", "-o", "test_plugin.so",
             "-shared", "-fPIC", "test_plugin.cpp", "-L#{opt_lib}",
             "-stdlib=libc++", "-rtlib=compiler-rt",
             "-static-libstdc++", "-lpthread", "-ldl"
      system bin"clang", "-v",
             "test_plugin_main.c", "-o", "test_plugin_libc++",
             "test_plugin.so", "-Wl,-rpath=#{testpath}", "-rtlib=compiler-rt"
      assert_equal "Hello Plugin World!", shell_output(".test_plugin_libc++").chomp
      (testpath"test_plugin.so").dynamically_linked_libraries.each do |lib|
        refute_match(lib(std)?c\+\+, lib)
        refute_match(libgcc, lib)
        refute_match(libatomic, lib)
        refute_match(libunwind, lib)
      end
    end

    # Testing mlir
    (testpath"test.mlir").write <<~MLIR
      func.func @main() {return}

       -----

       expected-note @+1 {{see existing symbol definition here}}
      func.func @foo() { return }

       ----

       expected-error @+1 {{redefinition of symbol named 'foo'}}
      func.func @foo() { return }
    MLIR
    system bin"mlir-opt", "--split-input-file", "--verify-diagnostics", "test.mlir"

    (testpath"scanbuildtest.cpp").write <<~CPP
      #include <iostream>
      int main() {
        int *i = new int;
        *i = 1;
        delete i;
        std::cout << *i << std::endl;
        return 0;
      }
    CPP
    assert_includes shell_output("#{bin}scan-build make scanbuildtest 2>&1"),
                    "warning: Use of memory after it is freed"

    (testpath"clangformattest.c").write <<~C
      int    main() {
          printf("Hello world!"); }
    C
    assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}clang-format -style=google clangformattest.c")

    # This will fail if the clang bindings cannot find `libclang`.
    with_env(PYTHONPATH: prefixLanguage::Python.site_packages(python3)) do
      system python3, "-c", <<~PYTHON
        from clang import cindex
        cindex.Config().get_cindex_library()
      PYTHON
    end

    unless versioned_formula?
      (testpath"omptest.c").write <<~C
        #include <stdlib.h>
        #include <stdio.h>
        #include <omp.h>
        int main() {
            #pragma omp parallel num_threads(4)
            {
              printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
            }
            return EXIT_SUCCESS;
        }
      C

      rpath_flag = "-Wl,-rpath,#{lib}#{Hardware::CPU.arch}-unknown-linux-gnu" if OS.linux?
      system bin"clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                          "-I#{lib}clang#{llvm_version_major}include",
                          rpath_flag.to_s, "omptest.c", "-o", "omptest"
      testresult = shell_output(".omptest")

      sorted_testresult = testresult.split("\n").sort.join("\n")
      expected_result = <<~EOS
        Hello from thread 0, nthreads 4
        Hello from thread 1, nthreads 4
        Hello from thread 2, nthreads 4
        Hello from thread 3, nthreads 4
      EOS
      assert_equal expected_result.strip, sorted_testresult.strip

      # Test static analyzer
      (testpath"unreachable.c").write <<~C
        unsigned int func(unsigned int a) {
          unsigned int *z = 0;
          if ((a & 1) && ((a & 1) ^1))
            return *z;  unreachable
          return 0;
        }
      C
      system bin"clang", "--analyze", "-Xanalyzer", "-analyzer-constraints=z3", "unreachable.c"

      # Check that lldb can use Python
      lldb_script_interpreter_info = JSON.parse(shell_output("#{bin}lldb --print-script-interpreter-info"))
      assert_equal "python", lldb_script_interpreter_info["language"]
      python_test_cmd = "import pathlib, sys; print(pathlib.Path(sys.prefix).resolve())"
      assert_match shell_output("#{python3} -c '#{python_test_cmd}'"),
                   pipe_output("#{bin}lldb", <<~EOS)
                     script
                     #{python_test_cmd}
                   EOS
    end

    # Ensure LLVM did not regress output of `llvm-config --system-libs` which for a time
    # was known to output incorrect linker flags; e.g., `-llibxml2.tbd` instead of `-lxml2`.
    # On the other hand, note that a fully qualified path to `dylib` or `tbd` is OK, e.g.,
    # `usrlocalliblibxml2.tbd` or `usrlocalliblibxml2.dylib`.
    abs_path_exts = [".tbd", ".dylib"]
    shell_output("#{bin}llvm-config --system-libs").chomp.strip.split.each do |lib|
      if lib.start_with?("-l")
        assert !lib.end_with?(".tbd"), "expected abs path when lib reported as .tbd"
        assert !lib.end_with?(".dylib"), "expected abs path when lib reported as .dylib"
      else
        p = Pathname.new(lib)
        if abs_path_exts.include?(p.extname)
          assert p.absolute?, "expected abs path when lib reported as .tbd or .dylib"
        end
      end
    end
  end
end