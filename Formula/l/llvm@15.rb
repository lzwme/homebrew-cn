class LlvmAT15 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https:llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-15.0.7llvm-project-15.0.7.src.tar.xz"
  sha256 "8b5fcb24b4128cf04df1b0b9410ce8b1a729cb3c544e6da885d234280dedeac6"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b767f1c1ae0719c1a8d1b5f7e7c7d9cead4eca26cab4b204c72800e824c06845"
    sha256 cellar: :any,                 arm64_ventura:  "e276f3ea90967ffe838f28280405e98ceb6c0b1452fde16019fd4bce899575f4"
    sha256 cellar: :any,                 arm64_monterey: "08432060d1e42f11dc887211a2ccc5ab7785d9283dccc37534b207c50a9aba54"
    sha256 cellar: :any,                 sonoma:         "08430f7b9a8b839fbc65b90f6e2ba5f7969daa8a6f05a6863a39b2af500527c1"
    sha256 cellar: :any,                 ventura:        "14244325d6f28f97dc28b77b668696c113696f8abc2e3c334a886c24a62e9f1b"
    sha256 cellar: :any,                 monterey:       "d1cb79d95fc313205141a904d2f631c0e8fea32957f7ddbf91566c2839e81675"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3a07622bd1154081b35df3aada0d62da27528a5d6fda372aaddb266ba143e6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d478121e56352a43a1942f8d93e2a3283772aee536eec2b358907e7e81af912c"
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? only_if: :clt_installed

  keg_only :versioned_formula

  # https:llvm.orgdocsGettingStarted.html#requirement
  # We intentionally use Make instead of Ninja.
  # See: Homebrewhomebrew-coreissues35513
  depends_on "cmake" => :build
  # sanitizer_mac.cpp:630:15: error: constexpr function never produces a constant expression [-Winvalid-constexpr]
  # constexpr u16 GetOSMajorKernelOffset() {
  depends_on maximum_macos: [:ventura, :build]
  depends_on "python@3.12" => [:build, :test]
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

  def python3
    "python3.12"
  end

  def install
    # The clang bindings need a little help finding our libclang.
    inreplace "clangbindingspythonclangcindex.py",
              ^(\s*library_path\s*=\s*)None$,
              "\\1'#{lib}'"

    projects = %w[
      clang
      clang-tools-extra
      lld
      mlir
      polly
    ]
    runtimes = %w[
      compiler-rt
      libcxx
      libcxxabi
      libunwind
    ]

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
      -DLLVM_ENABLE_Z3_SOLVER=OFF
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_ENABLE_PYTHON=OFF
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_ENABLE_LZMA=OFF
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DCLANG_PYTHON_BINDINGS_VERSIONS=#{python_versions.join(";")}
      -DLLVM_CREATE_XCODE_TOOLCHAIN=OFF
      -DCLANG_FORCE_MATCHING_LIBCLANG_SOVERSION=OFF
      -DPACKAGE_VENDOR=#{tap.user}
      -DBUG_REPORT_URL=#{tap.issues_url}
      -DCLANG_VENDOR_UTI=org.#{tap.user.downcase}.clang
    ]

    runtimes_cmake_args = []
    builtins_cmake_args = []

    if OS.mac?
      macos_sdk = MacOS.sdk_path_if_needed
      if MacOS.version >= :catalina
        args << "-DFFI_INCLUDE_DIR=#{macos_sdk}usrincludeffi"
        args << "-DFFI_LIBRARY_DIR=#{macos_sdk}usrlib"
      end

      args << "-DLLVM_BUILD_LLVM_C_DYLIB=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DLIBCXX_INSTALL_LIBRARY_DIR=#{lib}c++"
      args << "-DLIBCXXABI_INSTALL_LIBRARY_DIR=#{lib}c++"
      args << "-DDEFAULT_SYSROOT=#{macos_sdk}" if macos_sdk
      runtimes_cmake_args << "-DCMAKE_INSTALL_RPATH=#{loader_path}"

      # Prevent CMake from defaulting to `lld` when it's found next to `clang`.
      # This can be removed after CMake 3.25. See:
      # https:gitlab.kitware.comcmakecmake-merge_requests7671
      args << "-DLLVM_USE_LINKER=ld"
      [args, runtimes_cmake_args, builtins_cmake_args].each do |arg_array|
        arg_array << "-DCMAKE_LINKER=ld"
      end

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

    if ENV.cflags.present?
      args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
      runtimes_cmake_args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
      builtins_cmake_args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
    end

    if ENV.cxxflags.present?
      args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
      runtimes_cmake_args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
      builtins_cmake_args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
    end

    args << "-DRUNTIMES_CMAKE_ARGS=#{runtimes_cmake_args.join(";")}" if runtimes_cmake_args.present?
    args << "-DBUILTINS_CMAKE_ARGS=#{builtins_cmake_args.join(";")}" if builtins_cmake_args.present?

    llvmpath = buildpath"llvm"
    mkdir llvmpath"build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      # Linux fails with:
      # No rule to make target '#{buildpath}llvmbuildliblibunwind.so'
      ENV.deparallelize if OS.linux?
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end

    if OS.mac?
      llvm_version = Version.new(Utils.safe_popen_read(bin"llvm-config", "--version").strip)
      soversion = llvm_version.major.to_s

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
    end

    # Install LLVM Python bindings
    # Clang Python bindings are installed by CMake
    (libsite_packages).install llvmpath"bindingspythonllvm"

    # Create symlinks so that the Python bindings can be used with alternative Python versions
    python_versions.each do |py_ver|
      next if py_ver == Language::Python.major_minor_version(python3).to_s

      (lib"python#{py_ver}site-packages").install_symlink (libsite_packages).children
    end

    # Install Vim plugins
    %w[ftdetect ftplugin indent syntax].each do |dir|
      (share"vimvimfiles"dir).install Pathname.glob("*utilsvim#{dir}*.vim")
    end

    # Install Emacs modes
    elisp.install llvmpath.glob("utilsemacs*.el") + share.glob("clang*.el")
  end

  def caveats
    on_macos do
      <<~EOS
        To use the bundled libc++ please add the following LDFLAGS:
          LDFLAGS="-L#{opt_lib}c++ -Wl,-rpath,#{opt_lib}c++"
      EOS
    end
  end

  test do
    llvm_version = Version.new(Utils.safe_popen_read(bin"llvm-config", "--version").strip)
    soversion = llvm_version.major.to_s

    assert_equal version, llvm_version
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

    # Testing default toolchain and SDK location.
    system bin"clang++", "-v",
           "-std=c++11", "test.cpp", "-o", "test++"
    assert_includes MachO::Tools.dylibs("test++"), "usrliblibc++.1.dylib" if OS.mac?
    assert_equal "Hello World!", shell_output(".test++").chomp
    system bin"clang", "-v", "test.c", "-o", "test"
    assert_equal "Hello World!", shell_output(".test").chomp

    # To test `lld`, we mock a broken `ld` to make sure it's not what's being used.
    (testpath"fake_ld.c").write <<~C
      int main() { return 1; }
    C
    (testpath"bin").mkpath
    system ENV.cc, "-v", "fake_ld.c", "-o", "binld"
    with_env(PATH: "#{testpath}bin:#{ENV["PATH"]}") do
      # Our fake `ld` will produce a compilation error if it is used instead of `lld`.
      system bin"clang", "-v", "test.c", "-o", "test_lld", "-fuse-ld=lld"
    end
    assert_equal "Hello World!", shell_output(".test_lld").chomp

    # These tests should ignore the usual SDK includes
    with_env(CPATH: nil) do
      # Testing Command Line Tools
      if OS.mac? && MacOS::CLT.installed?
        toolchain_path = "LibraryDeveloperCommandLineTools"
        cpp_base = (MacOS.version >= :big_sur) ? MacOS::CLT.sdk_path : toolchain_path
        system bin"clang++", "-v",
               "-isysroot", MacOS::CLT.sdk_path,
               "-isystem", "#{cpp_base}usrincludec++v1",
               "-isystem", "#{MacOS::CLT.sdk_path}usrinclude",
               "-isystem", "#{toolchain_path}usrinclude",
               "-std=c++11", "test.cpp", "-o", "testCLT++"
        assert_includes MachO::Tools.dylibs("testCLT++"), "usrliblibc++.1.dylib"
        assert_equal "Hello World!", shell_output(".testCLT++").chomp
        system bin"clang", "-v", "test.c", "-o", "testCLT"
        assert_equal "Hello World!", shell_output(".testCLT").chomp
      end

      # Testing Xcode
      if OS.mac? && MacOS::Xcode.installed?
        cpp_base = (MacOS::Xcode.version >= "12.5") ? MacOS::Xcode.sdk_path : MacOS::Xcode.toolchain_path
        system bin"clang++", "-v",
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