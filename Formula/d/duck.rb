class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https:duck.sh"
  url "https:dist.duck.shduck-src-9.1.2.42722.tar.gz"
  sha256 "13f496860b36358dedbbba1d45d40758566b9ec8f657e789bcdcac1a66f3b72c"
  license "GPL-3.0-only"
  head "https:github.comiterate-chcyberduck.git", branch: "master"

  livecheck do
    url "https:dist.duck.sh"
    regex(href=.*?duck(?:-src)?[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "de5427ed1c9db98edd4c633d948b8a1a8d488077e28cfca013159785d7cb4c96"
    sha256 cellar: :any, arm64_sonoma:  "d18bdc35d038bc7a8667c10b41a9c9b8367b553adaf2920b0c1b52a64950f38d"
    sha256 cellar: :any, arm64_ventura: "5a345c332e1f280810bccbc6b1e78cbd7676032e29a23b4c3b522c82221958c4"
    sha256 cellar: :any, sonoma:        "6b9f64369e33d5c0a580990eb0ea3d18c9f37698842f30e2dcbb9bdd8479a754"
    sha256 cellar: :any, ventura:       "05b443e05dab27348dc8d331b1e79c3e65570d15fd8bf69569942bd40c0e1bd3"
    sha256               x86_64_linux:  "eeb0cfd0629c64025dc5dda88b9be7059254da331d53c0ae5bd8f7ece093f485"
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: ["13.1", :build]
  depends_on "openjdk"

  uses_from_macos "libffi", since: :monterey # Uses `FFI_BAD_ARGTYPE`.
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "freetype"
    depends_on "giflib"
    depends_on "harfbuzz"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "little-cms2"
  end

  conflicts_with "duckscript", because: "both install `duck` binaries"

  resource "jna" do
    url "https:github.comjava-native-accessjnaarchiverefstags5.15.0.tar.gz"
    sha256 "30f857756ea29870c8a0c7eff5f0e0b38fdd01c1f26bd9b0f4af02a7d3643179"
  end

  resource "rococoa" do
    url "https:github.comiterate-chrococoaarchiverefstags0.9.1.tar.gz"
    sha256 "62c3c36331846384aeadd6014c33a30ad0aaff7d121b775204dc65cb3f00f97b"
  end

  resource "JavaNativeFoundation" do
    url "https:github.comappleopenjdkarchiverefstagsiTunesOpenJDK-1014.0.2.12.1.tar.gz"
    sha256 "e8556a73ea36c75953078dfc1bafc9960e64593bc01e733bc772d2e6b519fd4a"
  end

  def install
    # Consider creating a formula for this if other formulae need the same library
    resource("jna").stage do
      os = if OS.mac?
        inreplace "nativeMakefile" do |s|
          libffi_libdir = if MacOS.version >= :monterey
            MacOS.sdk_path"usrlib"
          else
            Formula["libffi"].opt_lib
          end
          # Add linker flags for libffi because Makefile call to pkg-config doesn't seem to work properly.
          s.change_make_var! "LIBS", "-L#{libffi_libdir} -lffi"
          library_var = s.get_make_var("LIBRARY")
          # Force shared library to have dylib extension on macOS instead of jnilib
          s.change_make_var! "LIBRARY", library_var.sub("JNISFX", "LIBSFX")
        end

        "mac"
      else
        OS.kernel_name
      end

      # Don't include directory with JNA headers in zip archive.  If we don't do this, they will be deleted
      # and the zip archive has to be extracted to get them. TODO: ask upstream to provide an option to
      # disable the zip file generation entirely.
      inreplace "build.xml",
                "<zipfileset dir=\"buildheaders\" prefix=\"build-package-${os.prefix}-${jni.version}headers\" >",
                ""

      system "ant", "-Dbuild.os.name=#{os}",
                    "-Dbuild.os.arch=#{Hardware::CPU.arch}",
                    "-Ddynlink.native=true",
                    "-DCC=#{ENV.cc}",
                    "native-build-package"

      cd "build" do
        ENV.deparallelize
        ENV["JAVA_HOME"] = Language::Java.java_home(Formula["openjdk"].version.major.to_s)

        inreplace "build.sh" do |s|
          # Fix zip error on macOS because libjnidispatch.dylib is not in file list
          s.gsub! "libjnidispatch.so", "libjnidispatch.so libjnidispatch.dylib" if OS.mac?
          # Fix relative path in build script, which is designed to be run out extracted zip archive
          s.gsub! "cd native", "cd ..native"
        end

        system "sh", "build.sh"
        buildpath.install shared_library("libjnidispatch")
      end
    end

    resource("JavaNativeFoundation").stage do
      next unless OS.mac?

      cd "appleJavaNativeFoundation" do
        xcodebuild "VALID_ARCHS=#{Hardware::CPU.arch}",
                   "OTHER_CFLAGS=-Wno-strict-prototypes", # Workaround for Xcode 14.3
                   "-project", "JavaNativeFoundation.xcodeproj"
        buildpath.install "buildReleaseJavaNativeFoundation.framework"
      end
    end

    resource("rococoa").stage do
      next unless OS.mac?

      # Set MACOSX_DEPLOYMENT_TARGET to avoid linker errors when building rococoa.
      xcconfig = buildpath"Overrides.xcconfig"
      xcconfig.write <<~EOS
        OTHER_LDFLAGS = -headerpad_max_install_names
        VALID_ARCHS=#{Hardware::CPU.arch}
        MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}
      EOS
      ENV["XCODE_XCCONFIG_FILE"] = xcconfig

      cd "rococoarococoa-core" do
        xcodebuild "VALID_ARCHS=#{Hardware::CPU.arch}", "-project", "rococoa.xcodeproj"
        buildpath.install shared_library("buildReleaselibrococoa")
      end
    end

    os = if OS.mac?
      "osx"
    else
      OS.kernel_name.downcase
    end

    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dconfiguration=default", "-Dgit.commitsCount=#{revision}",
                  "--projects", "cli#{os}", "--also-make", "verify"

    libdir, bindir = if OS.mac?
      %w[ContentsFrameworks ContentsMacOS]
    else
      %w[libapp bin]
    end.map { |dir| libexecdir }

    if OS.mac?
      libexec.install Dir["cliosxtargetduck.bundle*"]

      # Remove the `*.tbd` files. They're not needed, and they cause codesigning issues.
      buildpath.glob("JavaNativeFoundation.framework**JavaNativeFoundation.tbd").map(&:unlink)
      rm_r(libdir"JavaNativeFoundation.framework")
      libdir.install buildpath"JavaNativeFoundation.framework"

      rm libdirshared_library("librococoa")
      libdir.install buildpathshared_library("librococoa")

      # Replace runtime with already installed dependency
      rm_r libexec"ContentsPlugInsRuntime.jre"
      ln_s Formula["openjdk"].libexec"openjdk.jdk", libexec"ContentsPlugInsRuntime.jre"
    else
      libexec.install Dir["clilinuxtargetdefaultduck*"]
    end

    rm libdirshared_library("libjnidispatch")
    libdir.install buildpathshared_library("libjnidispatch")
    bin.install_symlink "#{bindir}duck" => "duck"
  end

  test do
    system bin"duck", "--download", "https:ftp.gnu.orggnuwgetwget-1.19.4.tar.gz", testpath"test"
    assert_equal (testpath"test").sha256, "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"
  end
end