class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://v8.dev/docs"
  # Track V8 version from Chrome stable: https://chromiumdash.appspot.com/releases?platform=Mac
  # Check `brew livecheck --resources v8` for any resource updates
  url "https://ghfast.top/https://github.com/v8/v8/archive/refs/tags/14.5.201.5.tar.gz"
  sha256 "59f6b689a7c168101ba1908c42effec4919c6973f47ddf56259da0ed8a9550f0"
  license "BSD-3-Clause"

  livecheck do
    url "https://chromiumdash.appspot.com/fetch_releases?channel=Stable&platform=Mac"
    regex(/(\d+\.\d+\.\d+\.\d+)/i)
    strategy :json do |json, regex|
      # Find the v8 commit hash for the newest Chromium release version
      v8_hash = json.max_by { |item| Version.new(item["version"]) }.dig("hashes", "v8")
      next if v8_hash.blank?

      # Check the v8 commit page for version text
      v8_page = Homebrew::Livecheck::Strategy.page_content(
        "https://chromium.googlesource.com/v8/v8.git/+/#{v8_hash}",
      )
      v8_page[:content]&.scan(regex)&.map { |match| match[0] }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0ac6e00b7bd9e7cdf199bbbdc216ff155bb16c8e554e414625d011e6ebdbb61"
    sha256 cellar: :any,                 arm64_sequoia: "9ae8558d17dd0a765ba8854c90c6861eaeeb4689b5ca7ab544577e48a67cb563"
    sha256 cellar: :any,                 arm64_sonoma:  "528f15654eb8df82553505279b162037515c7ed74841e5f76a2bbbceb7b68a60"
    sha256 cellar: :any,                 sonoma:        "b7d7d4c65368fac3fb195cb797eef79cd12bc3487077923d4316868539d637de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ad5afceee6ed1954b4626ab7c8fda88016dfc03b4fd7b9e9ebf2d2170b97bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0164bad901d11b0c204d5d52fc91fbd5c213d24ec146002de15e2170662efff7"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on xcode: ["10.0", :build] # for xcodebuild, min version required by v8

  uses_from_macos "python" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "pkgconf" => :build
    depends_on "glib"
  end

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://chromium.googlesource.com/v8/v8.git/+/refs/tags/<version>/DEPS#74
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "5550ba0f4053c3cbb0bff3d60ded9d867b6fa371"
    version "5550ba0f4053c3cbb0bff3d60ded9d867b6fa371"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(/["']gn_version["']:\s*["']git_revision:([0-9a-f]+)["']/i)
    end
  end

  resource "build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "d747365c051153cc89f25e6adc95538aabcdd319"
    version "d747365c051153cc89f25e6adc95538aabcdd319"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/build\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/src/buildtools.git",
        revision: "4dc32b3f510b330137385e2b3a631ca8e13a8e22"
    version "4dc32b3f510b330137385e2b3a631ca8e13a8e22"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/buildtools\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/abseil-cpp" do
    url "https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp.git",
        revision: "1597226b825a16493de66c1732171efe89b271d9"
    version "1597226b825a16493de66c1732171efe89b271d9"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/abseil-cpp\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/dragonbox/src" do
    url "https://chromium.googlesource.com/external/github.com/jk-jeon/dragonbox.git",
        revision: "beeeef91cf6fef89a4d4ba5e95d47ca64ccb3a44"
    version "beeeef91cf6fef89a4d4ba5e95d47ca64ccb3a44"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github\.com/jk-jeon/dragonbox\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/fast_float/src" do
    url "https://chromium.googlesource.com/external/github.com/fastfloat/fast_float.git",
        revision: "cb1d42aaa1e14b09e1452cfdef373d051b8c02a4"
    version "cb1d42aaa1e14b09e1452cfdef373d051b8c02a4"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/fastfloat/fast_float\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/fp16/src" do
    url "https://chromium.googlesource.com/external/github.com/Maratyszcza/FP16.git",
        revision: "3d2de1816307bac63c16a297e8c4dc501b4076df"
    version "3d2de1816307bac63c16a297e8c4dc501b4076df"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/Maratyszcza/FP16\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        revision: "4fe3307fb2d9f86d19777c7eb0e4809e9694dde7"
    version "4fe3307fb2d9f86d19777c7eb0e4809e9694dde7"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/google/googletest\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/highway/src" do
    url "https://chromium.googlesource.com/external/github.com/google/highway.git",
        revision: "84379d1c73de9681b54fbe1c035a23c7bd5d272d"
    version "84379d1c73de9681b54fbe1c035a23c7bd5d272d"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/google/highway\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "a86a32e67b8d1384b33f8fa48c83a6079b86f8cd"
    version "a86a32e67b8d1384b33f8fa48c83a6079b86f8cd"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/deps/icu\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
        revision: "c3027d884967773057bf74b957e3fea87e5df4d7"
    version "c3027d884967773057bf74b957e3fea87e5df4d7"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/jinja2\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
        revision: "4256084ae14175d38a3ff7d739dca83ae49ccec6"
    version "4256084ae14175d38a3ff7d739dca83ae49ccec6"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/markupsafe\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/partition_alloc" do
    url "https://chromium.googlesource.com/chromium/src/base/allocator/partition_allocator.git",
        revision: "b2155fca494c5b6266d42f9129ae3a7b85482c95"
    version "b2155fca494c5b6266d42f9129ae3a7b85482c95"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(/["']partition_alloc_version["']:\s*["']([0-9a-f]+)["']/i)
    end
  end

  resource "third_party/simdutf" do
    url "https://chromium.googlesource.com/chromium/src/third_party/simdutf.git",
        revision: "75bea7342fdac6b57f7e3099ddf4dc84d77384f6"
    version "75bea7342fdac6b57f7e3099ddf4dc84d77384f6"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/simdutf["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
        revision: "2182f37a0861358faa9f6b8e0dacce32142c3a33"
    version "2182f37a0861358faa9f6b8e0dacce32142c3a33"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/zlib\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }

    # Build gn from source and add it to the PATH
    cd "gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end
    ENV.prepend_path "PATH", buildpath/"gn/out"

    # create gclient_args.gni
    (buildpath/"build/config/gclient_args.gni").write <<~GN
      declare_args() {
        checkout_google_benchmark = false
      }
    GN

    # setup gn args
    gn_args = {
      is_debug:                     false,
      is_component_build:           true,
      v8_use_external_startup_data: false,
      v8_enable_fuzztest:           false,
      v8_enable_i18n_support:       true,  # enables i18n support with icu
      clang_use_chrome_plugins:     false, # disable the usage of Google's custom clang plugins
      treat_warnings_as_errors:     false, # ignore not yet supported clang argument warnings
      # disable options which require Google's custom libc++
      use_custom_libcxx:            false,
      enable_rust:                  false,
      use_sysroot:                  false,
      v8_enable_temporal_support:   false,
    }

    # workaround to use shim to compile v8
    ENV.llvm_clang
    llvm = Formula["llvm"]
    clang_base_path = buildpath/"clang"
    clang_base_path.install_symlink (llvm.opt_prefix.children - [llvm.opt_bin])
    (clang_base_path/"bin").install_symlink llvm.opt_bin.children
    %w[clang clang++].each do |compiler|
      rm(clang_base_path/"bin"/compiler)
      (clang_base_path/"bin"/compiler).write_env_script Superenv.shims_path/"llvm_#{compiler}", _skip: ""
      chmod "+x", clang_base_path/"bin"/compiler
    end

    # uses Homebrew clang instead of Google clang
    gn_args[:clang_base_path] = "\"#{clang_base_path}\""
    gn_args[:clang_version] = "\"#{llvm.version.major}\""

    if OS.linux?
      ENV["AR"] = DevelopmentTools.locate("ar")
      ENV["NM"] = DevelopmentTools.locate("nm")
      gn_args[:use_sysroot] = false # don't use sysroot
      gn_args[:custom_toolchain] = "\"//build/toolchain/linux/unbundle:default\"" # uses system toolchain
      gn_args[:host_toolchain] = "\"//build/toolchain/linux/unbundle:default\"" # to respect passed LDFLAGS
      gn_args[:use_rbe] = false
    else
      ENV["DEVELOPER_DIR"] = ENV["HOMEBREW_DEVELOPER_DIR"] # help run xcodebuild when xcode-select is set to CLT
      gn_args[:use_lld] = false # upstream use LLD but this leads to build failure on ARM
    end

    # Make sure private libraries can be found from lib
    ENV.prepend "LDFLAGS", "-Wl,-rpath,#{rpath(target: libexec)}"

    # Transform to args string
    gn_args_string = gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")

    # Build with gn + ninja
    system "gn", "gen", "--args=#{gn_args_string}", "out.gn"
    system "ninja", "-j", ENV.make_jobs, "-C", "out.gn", "-v", "d8"

    # Install libraries and headers into libexec so d8 can find them, and into standard directories
    # so other packages can find them and they are linked into HOMEBREW_PREFIX
    libexec.install "include"

    # Make sure we don't symlink non-headers into `include`.
    header_files_and_directories = (libexec/"include").children.select do |child|
      (child.extname == ".h") || child.directory?
    end
    include.install_symlink header_files_and_directories

    libexec.install "out.gn/d8", "out.gn/icudtl.dat"
    bin.write_exec_script libexec/"d8"

    libexec.install Pathname.glob("out.gn/#{shared_library("*")}")
    lib.install_symlink libexec.glob(shared_library("libv8*"))
    lib.glob("*.TOC").map(&:unlink) if OS.linux? # Remove symlinks to .so.TOC text files
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/d8 -e 'print(\"Hello World!\");'").chomp
    t = "#{bin}/d8 -e 'print(new Intl.DateTimeFormat(\"en-US\").format(new Date(\"2012-12-20T03:00:00\")));'"
    assert_match %r{12/\d{2}/2012}, shell_output(t).chomp

    (testpath/"test.cpp").write <<~CPP
      #include <libplatform/libplatform.h>
      #include <v8.h>
      int main(){
        static std::unique_ptr<v8::Platform> platform = v8::platform::NewDefaultPlatform();
        v8::V8::InitializePlatform(platform.get());
        v8::V8::Initialize();
        return 0;
      }
    CPP

    # link against installed libc++
    system ENV.cxx, "-std=c++20", "test.cpp",
                    "-I#{include}", "-L#{lib}",
                    "-Wl,-rpath,#{libexec}",
                    "-lv8", "-lv8_libplatform"
  end
end