class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https:duck.sh"
  url "https:dist.duck.shduck-src-9.0.0.41777.tar.gz"
  sha256 "4c92be3cc3cce94788f971476b6d57cefd27ac6361706ebb2d1c9c0dfb4fa584"
  license "GPL-3.0-only"
  head "https:github.comiterate-chcyberduck.git", branch: "master"

  livecheck do
    url "https:dist.duck.sh"
    regex(href=.*?duck-src[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "661239af23ccfd59f22e22a2db029a636f818fbade09faffe3c00ae47acc6495"
    sha256 cellar: :any, arm64_ventura:  "3d756efd4c5e65b7cfabea0f293a68be6c8db7a116ffb147817cc9286bc864dc"
    sha256 cellar: :any, arm64_monterey: "addf05ef525f528b8708b7c311f4da514d37aac134d5fbe71c356296d32fc946"
    sha256 cellar: :any, sonoma:         "9e1288d352e60040f8ec53d8160f800629aa43f0f60ffbcdcfa706cf0502e749"
    sha256 cellar: :any, ventura:        "a1f4abc4594e6e75321966c94a1c80b043ebfb880e96ebddf9161f2929173839"
    sha256 cellar: :any, monterey:       "f67ff636102a1409a39b5b2cd7d1f32def79a576a84a80f0e1f2fae8361cf3f6"
    sha256               x86_64_linux:   "5c20014cdbabda4e533d8878c2547cbc1d23b397f2d702f332cb342da65092b0"
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: ["13.1", :build]
  depends_on "openjdk"

  uses_from_macos "libffi", since: :monterey # Uses `FFI_BAD_ARGTYPE`.
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrender"
    depends_on "libxtst"
  end

  resource "jna" do
    url "https:github.comjava-native-accessjnaarchiverefstags5.14.0.tar.gz"
    sha256 "b8a51f4c97708171fc487304f98832ce954b6c02e85780de71d18888fddc69e3"
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
      rm_rf libdir"JavaNativeFoundation.framework"
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
    system "#{bin}duck", "--download", "https:ftp.gnu.orggnuwgetwget-1.19.4.tar.gz", testpath"test"
    assert_equal (testpath"test").sha256, "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"
  end
end