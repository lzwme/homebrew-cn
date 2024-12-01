class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https:www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https:github.comswiftlangswiftarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
  sha256 "1489681860e92cee5ddd869a06531d7a1746b2f4ea105a2ff3b631ebcbcffd34"
  license "Apache-2.0"

  # This uses the `GithubLatest` strategy because a `-RELEASE` tag is often
  # created several days before the version is officially released.
  livecheck do
    url :stable
    regex(swift[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0da9c3b201fae6b553a89d23fe20941fb3a6df0d9ed92d6f9d6bb05c2dcbb34"
    sha256 cellar: :any,                 arm64_sonoma:  "8f8323c289d76a9d52c1864bc3d481d5e5a77e5d69f72aa85287494e70e0001c"
    sha256 cellar: :any,                 arm64_ventura: "d0c50a6389a459bf86177448ccbdcdfaae3d7c60a2f048c83c44680e5fd1f22b"
    sha256 cellar: :any,                 sonoma:        "dea817b03b25515a99efc836b3d05702a9aaad9e6d99f503acbf1c38667331d7"
    sha256 cellar: :any,                 ventura:       "b9cf1d9f5b8f378baec6c0a390c3a8a8bc8ca0a015794d6410f769aaa647a4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22319e6c3269a53d02b4f1e46b0cfdeb95919ec63631a03cfceb89494bb7812e"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # As a starting point, check `minimum_version` in `validate_xcode_compatibility`:
  # https:github.comswiftlangswifttreeswift-#{version}-RELEASEutilsbuild-script
  # This is community-sourced so may not be accurate. If the version in this formula
  # is higher then that is likely why.
  depends_on xcode: ["14.3", :build]

  depends_on "python@3.13"

  # HACK: this should not be a test dependency but is due to a limitation with fails_with
  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "rsync" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "python-setuptools" => :build # for distutils in lldb build
    depends_on "util-linux"
    depends_on "zstd" # implicit via curl; not important but might as well

    # Doesn't have to be in sync but does need to be no older than X.(Y - 1).0
    resource "bootstrap" do
      on_intel do
        url "https:download.swift.orgswift-5.10.1-releaseubuntu2204swift-5.10.1-RELEASEswift-5.10.1-RELEASE-ubuntu22.04.tar.gz"
        sha256 "cab1bfffd33b79ebd49f4b7475bef6c7eb2d60cf3948cbc693d61afabd23c282"
      end

      on_arm do
        url "https:download.swift.orgswift-5.10.1-releaseubuntu2204-aarch64swift-5.10.1-RELEASEswift-5.10.1-RELEASE-ubuntu22.04-aarch64.tar.gz"
        sha256 "871b00f0a7f96e0d28da53b232181c900a7540cb4be37fe4916c15ab411f83c9"
      end
    end

    resource "swift-corelibs-foundation" do
      url "https:github.comappleswift-corelibs-foundationarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
      sha256 "8af719f14a05cee2d32625cf455261fc74d13eeef3ba9e5b9547316743d5cde9"
    end

    resource "swift-foundation" do
      url "https:github.comappleswift-foundationarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
      sha256 "a677ad3a712fb4d8330bccd28904aaa1b10749264d57ad9370215a89156ba1d3"
    end

    resource "swift-foundation-icu" do
      url "https:github.comappleswift-foundation-icuarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
      sha256 "a48f0d6f998ba6db710f89f0e987c4cf00f3845338afae116ab3e29c04dad127"
    end

    resource "swift-corelibs-libdispatch" do
      url "https:github.comappleswift-corelibs-libdispatcharchiverefstagsswift-6.0.2-RELEASE.tar.gz"
      sha256 "3df429b22d9294c0ca5291c86e83a35f6326600a1c271933107bba199b919008"
    end

    resource "swift-corelibs-xctest" do
      url "https:github.comappleswift-corelibs-xctestarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
      sha256 "a671062f178c68dd1fb0fdcf6a7c00589b343a63009a59b522206e03c9850d97"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https:github.comswiftlangllvm-projectarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "991e9d63548a5ae8ce4fdda4052e98cb2bf2b193cafac8bbeea8f830f8cede96"

    # Fix copmatibility with macOS 15 SDK.
    # Remove with Swift 6.0.3.
    patch do
      url "https:github.comswiftlangllvm-projectcommita566c12aded130264a1e07e6c1718884ab1d9dc8.patch?full_index=1"
      sha256 "6f165b41390051098c0b4ea5bd333c49a7fd93740a015b99db72f096283ae434"
    end

    # Support Python 3.13.
    # Remove with Swift 6.1.
    patch do
      url "https:github.comswiftlangllvm-projectcommitb202bacbaf2be144dfd51d083eb2e4fe687a3803.patch?full_index=1"
      sha256 "a7368e3b91a3dc4ebfd78f61e865a621eee37c176ac88bea68f1327151e695cc"
    end
  end

  resource "cmark" do
    url "https:github.comswiftlangswift-cmarkarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "2bfeab8747f4bcfea6aa70ed0494fe2185ec2532f1c9b7a0e17214cd401e9f31"
  end

  resource "llbuild" do
    url "https:github.comswiftlangswift-llbuildarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "40ada0511f0218fb3ca0478c8fff1b4d0958478056a0cc5408677753e8c8f7a7"

    # Workaround Homebrew sqlite3 not being found.
    # Needs paired inreplace for @@HOMEBREW_PREFIX@@.
    # https:github.comswiftlangswift-llbuildissues901
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches0080c7317c51d16b17671640c5db665516402d2fswiftllbuild-sqlite3.patch"
      sha256 "97329a525dabf4a7a13d3e3237965e66ae456887776e0101e82b6ca125a97591"
    end
  end

  resource "swiftpm" do
    url "https:github.comswiftlangswift-package-managerarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "00e40c3bce9b63fdd24d783909af003c7f86431898ee6b8bf44174d023d08402"
  end

  resource "indexstore-db" do
    url "https:github.comswiftlangindexstore-dbarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "61f6d010edc11f31b5e01efb3628958501a1883b07ee4c741bbebc8c7d43d03d"

    # Fix compile with Clang 19.
    # Remove with Swift 6.1.
    patch do
      url "https:github.comswiftlangindexstore-dbcommit6120b53b1e8774ef4e2ad83438d4d94961331e72.patch?full_index=1"
      sha256 "1726948896ff5def5e3eb925cddd4ee24e488568ad6815023b43aa49f34874d6"
    end
  end

  resource "sourcekit-lsp" do
    url "https:github.comswiftlangsourcekit-lsparchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "26175c4774f9817ad32c62c004ca76e9f09d8b77a253fca0e4eafdb33f33b2d2"
  end

  resource "swift-driver" do
    url "https:github.comswiftlangswift-driverarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "c6db9d058c8d5122f8e368087e397d59cf17ce5be686d4713025269658f0467e"
  end

  resource "swift-tools-support-core" do
    url "https:github.comswiftlangswift-tools-support-corearchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "2f88a0790e9fe6fc0efa6a1fc1382d71c010126f871a6516ba56fb05dd1d23a0"

    # Fix "close error" when compiling SwiftPM.
    # https:github.comswiftlangswift-tools-support-corepull456
    patch do
      url "https:github.comBo98swift-tools-support-corecommitdca5ee70e302df065178cc8a75a2d6ea00886c40.patch?full_index=1"
      sha256 "e5e2e7cec7b7bd9ef0def5cfc9b1308fe1f25f6228973031c9821b2c4475c8a1"
    end
  end

  resource "swift-docc" do
    url "https:github.comswiftlangswift-doccarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "2fa482d6a3ba09a6bbdd9a503ae20a425e495c0c955dc2bd8ebafa64b38ca8ba"
  end

  resource "swift-lmdb" do
    url "https:github.comswiftlangswift-lmdbarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "384ce2942dbff106d6cca112b3f9a00be0ce3715a33c7b0b81dc61cc722ffdcd"
  end

  resource "swift-docc-render-artifact" do
    url "https:github.comswiftlangswift-docc-render-artifactarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "7411ed38dcb5a783ddd5c557290a7c2b939251a2ce634913a96a80b8a66c8c0c"
  end

  resource "swift-docc-symbolkit" do
    url "https:github.comswiftlangswift-docc-symbolkitarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "a310e60e64291fe8204b59b50c68d1e66bec3eb837ac8a5af8700ad09c819b1d"
  end

  resource "swift-markdown" do
    url "https:github.comswiftlangswift-markdownarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "7fedb25982044af33747162f1f249be279f26a043c96d7c4f2b20dcc3d689bdc"
  end

  resource "swift-experimental-string-processing" do
    url "https:github.comswiftlangswift-experimental-string-processingarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "e0380895e1cf5dc49aef321256f8192986185a6fa6ea83c143f171b643450fc0"
  end

  resource "swift-syntax" do
    url "https:github.comswiftlangswift-syntaxarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "82cb7640775a23cf7483197f0cd6a6342a29a61d4bb75239905490bf47a64a75"
  end

  resource "swift-testing" do
    url "https:github.comswiftlangswift-testingarchiverefstagsswift-6.0.2-RELEASE.tar.gz"
    sha256 "7c7160b1c196b83c36225d2d60dce27b0dd288b94bd1da7ff619d56b4071cf12"
  end

  # To find the version to use, check the release#{version.major_minor} entry of:
  # https:github.comswiftlangswiftblobswift-#{version}-RELEASEutilsupdate_checkoutupdate-checkout-config.json
  resource "swift-argument-parser" do
    url "https:github.comappleswift-argument-parserarchiverefstags1.2.3.tar.gz"
    sha256 "4a10bbef290a2167c5cc340b39f1f7ff6a8cf4e1b5433b68548bf5f1e542e908"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-atomics" do
    url "https:github.comappleswift-atomicsarchiverefstags1.2.0.tar.gz"
    sha256 "33d9f4fbaeddee4bda3af2be126791ee8acf3d3c24a2244457641a20d39aec12"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-collections" do
    url "https:github.comappleswift-collectionsarchiverefstags1.1.2.tar.gz"
    sha256 "cd30d2f93c72424df48d182006417abdeebe74d250cb99d1cda78daf40aca569"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-crypto" do
    url "https:github.comappleswift-cryptoarchiverefstags3.0.0.tar.gz"
    sha256 "5c860c0306d0393ff06268f361aaf958656e1288353a0e23c3ad20de04319154"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-certificates" do
    url "https:github.comappleswift-certificatesarchiverefstags1.0.1.tar.gz"
    sha256 "fcaca458aab45ee69b0f678b72c2194b15664cc5f6f5e48d0e3f62bc5d1202ca"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-asn1" do
    url "https:github.comappleswift-asn1archiverefstags1.0.0.tar.gz"
    sha256 "e0da995ae53e6fcf8251887f44d4030f6600e2f8f8451d9c92fcaf52b41b6c35"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-numerics" do
    url "https:github.comappleswift-numericsarchiverefstags1.0.2.tar.gz"
    sha256 "786291c6ff2a83567928d3d8f964c43ff59bdde215f9dedd0e9ed49eb5184e59"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-system" do
    url "https:github.comappleswift-systemarchiverefstags1.3.0.tar.gz"
    sha256 "02e13a7f77887c387f5aa1de05f4d4b8b158c35145450e1d9557d6c42b06cd1f"
  end

  # As above: refer to update-checkout-config.json
  resource "yams" do
    url "https:github.comjpsimYamsarchiverefstags5.0.6.tar.gz"
    sha256 "a81c6b93f5d26bae1b619b7f8babbfe7c8abacf95b85916961d488888df886fb"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio" do
    url "https:github.comappleswift-nioarchiverefstags2.31.2.tar.gz"
    sha256 "8818b8e991d36e886b207ae1023fa43c5eada7d6a1951a52ad70f7f71f57d9fe"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio-ssl" do
    url "https:github.comappleswift-nio-sslarchiverefstags2.15.0.tar.gz"
    sha256 "9ab1f0e347fad651ed5ccadc13d54c4306e6f5cd21908a4ba7d1334278a4cd55"
  end

  # Fix build with Xcode 16.
  # Remove with Swift 6.1 (or earlier if it gets cherry-picked).
  patch do
    url "https:github.comswiftlangswiftcommitc8d7e94fdd2c8ceb276a6dc363861872f13104ba.patch?full_index=1"
    sha256 "aa012b9522ddbe92da9ab6a491dd43097b723e7807e813c57edd458f4baf3b12"
  end

  # Homebrew-specific patch to make the default resource directory use opt rather than Cellar.
  # This fixes output binaries from `swiftc` having a runpath pointing to the Cellar.
  # This should only be removed if an alternative solution is implemented.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches5e4d9bb4d04c7c9004e95fecba362a843dc00bddswifthomebrew-resource-dir.diff"
    sha256 "5210ca0fd95b960d596c058f5ac76412a6987d2badf5394856bb9e31d3c68833"
  end

  def install
    workspace = buildpath.parent
    build = workspace"build"

    install_prefix = if OS.mac?
      toolchain_prefix = "Swift-#{version.major_minor}.xctoolchain"
      "#{toolchain_prefix}usr"
    else
      "libexec"
    end

    ln_sf buildpath, workspace"swift"
    resources.each { |r| r.stage(workspacer.name) }

    # Disable invoking SwiftPM in a sandbox while building some projects.
    # This conflicts with Homebrew's sandbox.
    helpers_using_swiftpm = [
      workspace"indexstore-dbUtilitiesbuild-script-helper.py",
      workspace"sourcekit-lspUtilitiesbuild-script-helper.py",
      workspace"swift-doccbuild-script-helper.py",
    ]
    inreplace helpers_using_swiftpm, "swiftpm_args = [", "\\0'--disable-sandbox',"
    inreplace workspace"swift-doccbuild-script-helper.py",
              "[swift_exec, 'package',",
              "\\0 '--disable-sandbox',"

    # Fix swift-driver somehow bypassing the shims.
    inreplace workspace"swift-driverUtilitiesbuild-script-helper.py",
              "-DCMAKE_C_COMPILER:=clang",
              "-DCMAKE_C_COMPILER:=#{which(ENV.cc)}"
    inreplace workspace"swift-driverUtilitiesbuild-script-helper.py",
              "-DCMAKE_CXX_COMPILER:=clang++",
              "-DCMAKE_CXX_COMPILER:=#{which(ENV.cxx)}"

    # Fix lldb Python module not being installed (needed for `swift repl`)
    inreplace workspace"llvm-projectlldbcmakecachesApple-lldb-macOS.cmake",
              "repl_swift",
              "lldb-python-scripts \\0"

    # Fix Linux RPATH for Swift Foundation
    if OS.linux?
      inreplace [
        workspace"swift-corelibs-foundationSourcesFoundationNetworkingCMakeLists.txt",
        workspace"swift-corelibs-foundationSourcesFoundationXMLCMakeLists.txt",
      ], '"$ORIGIN"', "\"$ORIGIN:#{ENV["HOMEBREW_RPATH_PATHS"]}\""
    end

    extra_cmake_options = if OS.mac?
      %W[
        -DSQLite3_INCLUDE_DIR=#{MacOS.sdk_for_formula(self).path}usrinclude
        -DSQLite3_LIBRARY=#{MacOS.sdk_for_formula(self).path}usrliblibsqlite3.tbd
      ]
    else
      []
    end

    # Inject our CMake args into the SwiftPM build
    inreplace workspace"swiftpmUtilitiesbootstrap",
              '"-DCMAKE_BUILD_TYPE:=Debug",',
              "\"-DCMAKE_BUILD_TYPE:=Release\", \"#{extra_cmake_options.join('", "')}\","

    mkdir build do
      # List of components to build
      swift_components = %w[
        autolink-driver compiler clang-resource-dir-symlink
        libexec tools editor-integration toolchain-tools
        license sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers stdlib
        static-mirror-lib
      ]
      llvm_components = %w[
        llvm-ar llvm-ranlib llvm-cov llvm-profdata IndexStore
        clang clang-resource-headers compiler-rt
        clangd clang-features-file lld
      ]

      if OS.mac?
        swift_components << "back-deployment"
        llvm_components << "dsymutil"
      end
      if OS.linux?
        swift_components += %w[
          sdk-overlay
          sourcekit-inproc
        ]
      end

      args = %W[
        --host-cc=#{which(ENV.cc)}
        --host-cxx=#{which(ENV.cxx)}
        --release --no-assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --lldb --llbuild --swiftpm --swift-driver
        --swiftdocc --indexstore-db --sourcekit-lsp
        --swift-testing --swift-testing-macros
        --jobs=#{ENV.make_jobs}
        --verbose-build

        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --swift-include-tests=0
        --llvm-include-tests=0
        --lldb-configure-tests=0
        --lldb-extra-cmake-args=-DPython3_EXECUTABLE=#{which("python3.13")}
        --skip-build-benchmarks
        --build-swift-private-stdlib=0
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --install-llvm
        --llvm-install-components=#{llvm_components.join(";")}
        --install-lldb
        --install-llbuild
        --install-static-linux-config
        --install-swiftpm
        --install-swift-driver
        --install-swiftsyntax
        --install-swiftdocc
        --install-sourcekit-lsp
        --install-swift-testing
        --install-swift-testing-macros
      ]

      extra_cmake_options << "-DSWIFT_INCLUDE_TEST_BINARIES=OFF"

      if OS.mac?
        args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --darwin-deployment-version-osx=#{MacOS.version}
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=x86_64;arm64
          --lldb-use-system-debugserver
        ]
        args << "--swift-enable-backtracing=0" if MacOS.version < :sonoma
        extra_cmake_options += %W[
          -DSWIFT_STANDARD_LIBRARY_SWIFT_FLAGS=-disable-sandbox
          -DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=OFF
          -DSWIFT_HOST_LIBRARIES_RPATH=#{loader_path}
        ]

        ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["sqlite"].opt_lib
        ENV.remove "PKG_CONFIG_PATH", Formula["sqlite"].opt_lib"pkgconfig"
      end
      if OS.linux?
        args += %W[
          --libcxx=0
          --foundation
          --libdispatch
          --xctest

          --host-target=linux-#{Hardware::CPU.arch}
          --stdlib-deployment-targets=linux-#{Hardware::CPU.arch}
          --build-swift-static-stdlib
          --build-swift-static-sdk-overlay
          --install-foundation
          --install-libdispatch
          --install-xctest
        ]

        # For XCTest (https:github.comswiftlangswift-corelibs-xctestissues432) and sourcekitd-repl
        rpaths = [loader_path, rpath, rpath(target: lib"swiftlinux")]
        extra_cmake_options << "-DCMAKE_INSTALL_RPATH=#{rpaths.join(":")}"

        ENV.prepend_path "PATH", workspace"bootstrapusrbin"
      end

      args << "--extra-cmake-options=#{extra_cmake_options.join(" ")}"

      system "#{workspace}swiftutilsbuild-script", *args
    end

    if OS.mac?
      # Prebuild modules for faster first startup.
      ENV["SWIFT_EXEC"] = "#{prefix}#{install_prefix}binswiftc"
      MacOS.sdk_locator.all_sdks.each do |sdk|
        system "#{prefix}#{install_prefix}binswift", "build-sdk-interfaces",
               "-sdk", sdk.path,
               "-o", "#{prefix}#{install_prefix}libswiftmacosxprebuilt-modules",
               "-log-path", logs"build-sdk-interfaces",
               "-v"
      end
    else
      # Strip debugging info to make the bottle relocatable.
      binaries_to_strip = Pathname.glob("#{prefix}#{install_prefix}{bin,libswiftpm}***").select do |f|
        f.file? && f.elf?
      end
      system "strip", "--strip-debug", "--preserve-dates", *binaries_to_strip
    end

    bin.install_symlink Dir["#{prefix}#{install_prefix}bin{swift,sil,sourcekit}*"]
    man1.install_symlink "#{prefix}#{install_prefix}sharemanman1swift.1"
    elisp.install_symlink "#{prefix}#{install_prefix}shareemacssite-lispswift-mode.el"
    doc.install_symlink Dir["#{prefix}#{install_prefix}sharedocswift*"]

    rewrite_shebang detected_python_shebang, *Dir["#{prefix}#{install_prefix}bin*.py"]
  end

  def caveats
    on_macos do
      <<~EOS
        An Xcode toolchain has been installed to:
          #{opt_prefix}Swift-#{version.major_minor}.xctoolchain

        This can be symlinked for use within Xcode:
          ln -s #{opt_prefix}Swift-#{version.major_minor}.xctoolchain ~LibraryDeveloperToolchainsSwift-#{version.major_minor}.xctoolchain
      EOS
    end
  end

  test do
    # Don't use global cache which is long-lasting and often requires clearing.
    module_cache = testpath"ModuleCache"
    module_cache.mkdir

    (testpath"test.swift").write <<~'EOS'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }

      print("(\(base)^\(exponent_inner))^\(exponent_outer) == \(answer)")
    EOS
    output = shell_output("#{bin}swift -module-cache-path #{module_cache} -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output

    # Test accessing Foundation
    (testpath"foundation-test.swift").write <<~'EOS'
      import Foundation

      let swifty = URLComponents(string: "https:www.swift.org")!
      print("\(swifty.host!)")
    EOS
    output = shell_output("#{bin}swift -module-cache-path #{module_cache} -v foundation-test.swift")
    assert_match "www.swift.org\n", output

    # Test compiler
    system bin"swiftc", "-module-cache-path", module_cache, "-v", "foundation-test.swift", "-o", "foundation-test"
    output = shell_output(".foundation-test 2>&1") # check stderr too for dyld errors
    assert_equal "www.swift.org\n", output

    # Test Swift Package Manager
    ENV["SWIFTPM_MODULECACHE_OVERRIDE"] = module_cache
    mkdir "swiftpmtest" do
      system bin"swift", "package", "init", "--type=executable"
      cp "..foundation-test.swift", "Sourcesmain.swift"
      system bin"swift", "build", "--verbose", "--disable-sandbox"
      assert_match "www.swift.org\n", shell_output("#{bin}swift run --disable-sandbox")
    end

    # Make sure the default resource directory is not using a Cellar path
    default_resource_dir = JSON.parse(shell_output("#{bin}swift -print-target-info"))["paths"]["runtimeResourcePath"]
    expected_resource_dir = if OS.mac?
      opt_prefix"Swift-#{version.major_minor}.xctoolchainusrlibswift"
    else
      opt_libexec"libswift"
    end.to_s
    assert_equal expected_resource_dir, default_resource_dir
  end
end