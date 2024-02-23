class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https:www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https:github.comappleswiftarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
  sha256 "5b93c737c24ba7d861e0777800740eaa9ccddfa2a6a4326bd47dbc5aa9ae8379"
  license "Apache-2.0"

  # This uses the `GithubLatest` strategy because a `-RELEASE` tag is often
  # created several days before the version is officially released.
  livecheck do
    url :stable
    regex(swift[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "323c4d0ce66fa558941a41aa233773fd0ffbb5a64e83ecbb651f4c1b89a96b5f"
    sha256 cellar: :any,                 arm64_ventura:  "5dc9fcfc4fbea5548131615a47dbd6fc5e0c8ccece4b44d1a492602c6cd3916a"
    sha256 cellar: :any,                 arm64_monterey: "92c46e35c501b6c7452e348d72f20cd9f07b8a87c44d3d4d5040af7fe02304f0"
    sha256 cellar: :any,                 sonoma:         "d8e792df249a4cab6c363db50b59590d5640f0f1ada93934f1c735a70381a1a9"
    sha256 cellar: :any,                 ventura:        "f682957f907edd64b3c71949e045448236fe576e11f5d2ad46b4e29d9a093e47"
    sha256 cellar: :any,                 monterey:       "6d40e3001405c4494851e0b981ab5878f07ac1a94f7ec42a1bf5de9a10d99d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4d1ed851dd2248a74db363f67f63c3e40b448a653f559bdfb1c826934ad3186"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # As a starting point, check `minimum_version` in `validate_xcode_compatibility`:
  # https:github.comappleswifttreeswift-#{version}-RELEASEutilsbuild-script
  # This is community-sourced so may not be accurate. If the version in this formula
  # is higher then that is likely why.
  depends_on xcode: ["13.3", :build]

  depends_on "python@3.11"

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
    depends_on "icu4c" # Used in swift-corelibs-foundation

    # Doesn't have to be in sync but does need to be no older than X.(Y - 1).0
    resource "bootstrap" do
      on_intel do
        url "https:download.swift.orgswift-5.9.2-releaseubuntu2204swift-5.9.2-RELEASEswift-5.9.2-RELEASE-ubuntu22.04.tar.gz"
        sha256 "6407e39eed7eaefcf7837d192d71765fb0f7cf8bf282c35b021171e8b15617c1"
      end

      on_arm do
        url "https:download.swift.orgswift-5.9.2-releaseubuntu2204-aarch64swift-5.9.2-RELEASEswift-5.9.2-RELEASE-ubuntu22.04-aarch64.tar.gz"
        sha256 "942e58de3384c9ca57f9e136be4fab7a7e799ee3269c70f35d60b3fee0f1e2fe"
      end
    end

    resource "swift-corelibs-foundation" do
      url "https:github.comappleswift-corelibs-foundationarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
      sha256 "e58c529ababd547cf0b205fc0820ccce38a033664625c271110b564f2554dd44"
    end

    resource "swift-corelibs-libdispatch" do
      url "https:github.comappleswift-corelibs-libdispatcharchiverefstagsswift-5.9.2-RELEASE.tar.gz"
      sha256 "b1f3e46ed248df6a3456d20bc23b2d8a12b740a40185d81b668b1d31735cadf2"
    end

    resource "swift-corelibs-xctest" do
      url "https:github.comappleswift-corelibs-xctestarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
      sha256 "7f0d21ce0bb15ed5275b0d6e5ee1747344d9756c9f1913a644a0b2142ee1fb19"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https:github.comapplellvm-projectarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "9df7cacc0107202dcdee8025d5cec9fe413f164e28921372acc61fddd78ed473"

    # Fix finding Homebrew Python executable on Linux.
    # Remove with Swift 5.10+.
    patch do
      url "https:github.comapplellvm-projectcommit9e84e038447e283d020ae01aebb15e0e66ef3642.patch?full_index=1"
      sha256 "a46a6e9bf5309c1cb9c387e9648c6604a60f9cb3880463993ed72df4404f14ca"
    end

    # Fix compile with unpatched bootstrap Swift.
    # Remove with Swift 5.10+.
    patch do
      url "https:github.comapplellvm-projectcommit8c76a69c00a8ca5fb9c063ff99c7d91511865bf2.patch?full_index=1"
      sha256 "62c4e296983a4bf14e94302bfd3292e232c54badb86e4b2cac02e8d495eece78"
    end
  end

  resource "cmark" do
    url "https:github.comappleswift-cmarkarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "658f4eb94f271e68af4ae07f4214f58d36dfc8edd7fc17ac44e8c85bec984337"
  end

  resource "llbuild" do
    url "https:github.comappleswift-llbuildarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "44bcb0f8c6fa6cccdc16b7e75c996987568d8fde3caf8bc83c24a2e10383406f"

    # Workaround Homebrew sqlite3 not being found.
    # Needs paired inreplace for @@HOMEBREW_PREFIX@@.
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches0080c7317c51d16b17671640c5db665516402d2fswiftllbuild-sqlite3.patch"
      sha256 "97329a525dabf4a7a13d3e3237965e66ae456887776e0101e82b6ca125a97591"
    end
  end

  resource "swiftpm" do
    url "https:github.comappleswift-package-managerarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "132ae4908fa9c8f10265585f593dc748a021a18b11d6a1881e22d2db2dd1e162"
  end

  resource "indexstore-db" do
    url "https:github.comappleindexstore-dbarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "a907c8fce27e718c179f6a92b73df62675e44b86612116468ff6ebd3f2997b31"
  end

  resource "sourcekit-lsp" do
    url "https:github.comapplesourcekit-lsparchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "0db3e5c56f2889a3be2ff4e9b5a285085459dee6f821c0cdf513eb5c9cc94ae4"
  end

  resource "swift-driver" do
    url "https:github.comappleswift-driverarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "e4db5194e99ebbd605a14b86965b301b5a060482ecd1c5c94a4a099de5754e35"
  end

  resource "swift-tools-support-core" do
    url "https:github.comappleswift-tools-support-corearchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "e0ab6f07998865549ad4bff34c91a3947a50a0085890d2d32605dfff296980c8"

    # Fix "close error" when compiling SwiftPM.
    # https:github.comappleswift-tools-support-corepull456
    # Remove with Swift 5.11?
    patch do
      url "https:github.comBo98swift-tools-support-corecommit151e8fbd599a440c9931eae2a92221dd6d448dc6.patch?full_index=1"
      sha256 "d17f14ac12abcad3169d736665f43e3fef0c7a15a4812bb04c3b2237da0dfa19"
    end
  end

  resource "swift-docc" do
    url "https:github.comappleswift-doccarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "5c2f2a68280d476b0d5559b38ffd46cb2f04d3d2e7436d9e2ddccf6555a9888f"
  end

  resource "swift-lmdb" do
    url "https:github.comappleswift-lmdbarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "0bafb61c6d8924626a9b130f3bcf9b92139f52a86aa1fa04539b83bc668c4b58"
  end

  resource "swift-docc-render-artifact" do
    url "https:github.comappleswift-docc-render-artifactarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "be134a7655345544eec00b52d097f4ca4a88333b17d32f3fb72f367aca335f96"
  end

  resource "swift-docc-symbolkit" do
    url "https:github.comappleswift-docc-symbolkitarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "fb95cecf2de170066d9529dafe0a74781b94c4262891e4f0751693662c48e30d"
  end

  resource "swift-markdown" do
    url "https:github.comappleswift-markdownarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "5b00363c4704e8b77bf78f127a734cfaf6fcda9e8898f3340fc4c8745e37e2c5"
  end

  resource "swift-experimental-string-processing" do
    url "https:github.comappleswift-experimental-string-processingarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "3abc4225789e19defae966f7d9a712c77a5c0366f1d44d37df671048fe62daf6"
  end

  resource "swift-syntax" do
    url "https:github.comappleswift-syntaxarchiverefstagsswift-5.9.2-RELEASE.tar.gz"
    sha256 "b1918519f5bc6c7820f14242adfe26d9520a91896349a486359d9809b4e89351"
  end

  # To find the version to use, check the release#{version.major_minor} entry of:
  # https:github.comappleswiftblobswift-#{version}-RELEASEutilsupdate_checkoutupdate-checkout-config.json
  resource "swift-argument-parser" do
    url "https:github.comappleswift-argument-parserarchiverefstags1.2.2.tar.gz"
    sha256 "44782ba7180f924f72661b8f457c268929ccd20441eac17301f18eff3b91ce0c"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-atomics" do
    url "https:github.comappleswift-atomicsarchiverefstags1.0.2.tar.gz"
    sha256 "c8b88186db4902dc5109340f4a745ea787cb2aa9533c7e6d1e634549f9e527b1"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-collections" do
    url "https:github.comappleswift-collectionsarchiverefstags1.0.1.tar.gz"
    sha256 "575cf0f88d9068411f9acc6e3ca5d542bef1cc9e87dc5d69f7b5a1d5aec8c6b6"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-crypto" do
    url "https:github.comappleswift-cryptoarchiverefstags2.5.0.tar.gz"
    sha256 "a7b2f5c4887ccd728cdff5d1162b4d4d36bd6c2df9c0c31d5b9b73d341c5c1bb"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-certificates" do
    url "https:github.comappleswift-certificatesarchiverefstags0.4.1.tar.gz"
    sha256 "d7699ce91d65a622c1b9aaa0235cbbbd1be4ddc42a90fce007ff74bef50e8985"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-asn1" do
    url "https:github.comappleswift-asn1archiverefstags0.7.0.tar.gz"
    sha256 "d4470d61788194abbd60ed73965ee0722cc25037e83d41226a8a780088ba524e"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-numerics" do
    url "https:github.comappleswift-numericsarchiverefstags1.0.1.tar.gz"
    sha256 "3ff05bb89c907d70f51dfff794ea3354a2630488925bf53382246d25089ec742"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-system" do
    url "https:github.comappleswift-systemarchiverefstags1.1.1.tar.gz"
    sha256 "865b8c380455eef27e73109835142920c60ae4c4f4178a3d12ad04acc83f1371"
  end

  # As above: refer to update-checkout-config.json
  resource "yams" do
    url "https:github.comjpsimYamsarchiverefstags5.0.1.tar.gz"
    sha256 "ec1ad699c30f0db45520006c63a88cc1c946a7d7b36dff32a96460388c0a4af2"
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

    # Fix C++ header path. It wrongly assumes that it's relative to our shims.
    if OS.mac?
      inreplace workspace"swiftutilsbuild-script-impl",
                "HOST_CXX_DIR=$(dirname \"${HOST_CXX}\")",
                "HOST_CXX_DIR=\"#{MacOS::Xcode.toolchain_path}usrbin\""
    end

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

    # Build SwiftPM and dependents in release mode
    inreplace workspace"swiftpmUtilitiesbootstrap",
              "-DCMAKE_BUILD_TYPE:=Debug",
              "-DCMAKE_BUILD_TYPE:=Release"

    # Fix lldb Python module not being installed (needed for `swift repl`)
    lldb_cmake_caches = [
      workspace"llvm-projectlldbcmakecachesApple-lldb-macOS.cmake",
      workspace"llvm-projectlldbcmakecachesApple-lldb-Linux.cmake",
    ]
    inreplace lldb_cmake_caches, "repl_swift", "lldb-python-scripts \\0"

    # Paired with llbuild patch
    inreplace workspace"llbuildPackage.swift", "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

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
        llvm-ar llvm-cov llvm-profdata IndexStore
        clang clang-resource-headers compiler-rt
        clangd clang-features-file
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
        llvm_components << "lld"
      end

      args = %W[
        --host-cc=#{which(ENV.cc)}
        --host-cxx=#{which(ENV.cxx)}
        --release --no-assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --lldb --llbuild --swiftpm --swift-driver
        --swiftdocc --indexstore-db --sourcekit-lsp
        --jobs=#{ENV.make_jobs}
        --verbose-build

        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --swift-include-tests=0
        --llvm-include-tests=0
        --lldb-configure-tests=0
        --lldb-extra-cmake-args=-DPython3_EXECUTABLE=#{which("python3.11")}
        --skip-build-benchmarks
        --build-swift-private-stdlib=0
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --install-llvm
        --llvm-install-components=#{llvm_components.join(";")}
        --install-lldb
        --install-llbuild
        --install-swiftpm
        --install-swift-driver
        --install-swiftsyntax
        --install-swiftdocc
        --install-sourcekit-lsp
      ]
      extra_cmake_options = []

      if OS.mac?
        # Backtracing currently requires stdlib - we may revisit in the future if part of the OS
        args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --darwin-deployment-version-osx=#{MacOS.version}
          --build-swift-dynamic-stdlib=0
          --build-swift-dynamic-sdk-overlay=0
          --swift-enable-backtracing=0
          --stdlib-deployment-targets=
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=#{Hardware::CPU.arch}
          --lldb-use-system-debugserver
        ]
        extra_cmake_options += %W[
          -DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=0
          -DCMAKE_INSTALL_RPATH=#{loader_path}
        ]
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
        next if sdk.version < :big_sur

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
    system "#{bin}swiftc", "-module-cache-path", module_cache, "-v", "foundation-test.swift", "-o", "foundation-test"
    output = shell_output(".foundation-test")
    assert_match "www.swift.org\n", output

    # Test Swift Package Manager
    ENV["SWIFTPM_MODULECACHE_OVERRIDE"] = module_cache
    mkdir "swiftpmtest" do
      system "#{bin}swift", "package", "init", "--type=executable"
      cp "..foundation-test.swift", "Sourcesmain.swift"
      system "#{bin}swift", "build", "--verbose", "--disable-sandbox"
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