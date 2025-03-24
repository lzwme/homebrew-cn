class OpenjdkAT8 < Formula
  desc "Development kit for the Java programming language"
  homepage "https:openjdk.java.net"
  url "https:github.comopenjdkjdk8uarchiverefstagsjdk8u442-ga.tar.gz"
  version "1.8.0-442"
  BUILD_NUMBER = "b06".freeze # Please update when a new GA release is available: https:wiki.openjdk.orgdisplayjdk8u.
  sha256 "3bc8175712037c85200f6a38b08e4160b906697b6617ae196ec5fd459cf5aff0"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^jdk(8u\d+)-ga$i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub("8u", "1.8.0+") }
    end
  end

  bottle do
    sha256 cellar: :any,                 sonoma:       "7db99e9fe66993bc4589aefc28ac5ce09347e624f787592e1243a7e1fc03ee35"
    sha256 cellar: :any,                 ventura:      "93b69835d88e596019e744c5572e10e1358e79cb0d50c92b4d08dba17110ff0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "8e7c574d7c1f31fd2c5868791d7c975316440bce1aec257d8aa4a82face776f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a4ae41b594c7fdcf0cb9542b00c00153baecf842ff1927777d3e6d131a7304dc"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_macos do
    depends_on arch: :x86_64
  end

  on_monterey :or_newer do
    depends_on "gawk" => :build
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
  end

  # NOTE: Oracle doesn't serve JDK 7 downloads anymore, so we use Zulu JDK 7 for bootstrapping.
  # https:www.azul.comdownloads?version=java-7-lts&package=jdk&show-old-builds=true#zulu
  resource "boot-jdk" do
    on_macos do
      url "https:cdn.azul.comzulubinzulu7.56.0.11-ca-jdk7.0.352-macosx_x64.tar.gz"
      sha256 "31909aa6233289f8f1d015586825587e95658ef59b632665e1e49fc33a2cdf06"
    end
    on_linux do
      on_arm do
        url "https:cdn.azul.comzulubinzulu8.82.0.21-ca-jdk8.0.432-linux_aarch64.tar.gz"
        sha256 "b400f65b63243e41851f20b64374def6ae687de8d15bfb37ef876c2d77548bf5"
      end
      on_intel do
        url "https:cdn.azul.comzulubinzulu7.56.0.11-ca-jdk7.0.352-linux_x64.tar.gz"
        sha256 "8a7387c1ed151474301b6553c6046f865dc6c1e1890bcf106acc2780c55727c8"
      end
    end
  end

  # NOTE: Since macOS Sonoma or newer don’t include the required headers for JNF (JavaNativeFoundation.framework),
  # we will use the headers provided at https:github.comappleopenjdk.
  resource "JavaNativeFoundation" do
    on_sonoma :or_newer do
      url "https:github.comappleopenjdkarchiverefstagsiTunesOpenJDK-1014.0.2.12.1.tar.gz"
      sha256 "e8556a73ea36c75953078dfc1bafc9960e64593bc01e733bc772d2e6b519fd4a"
    end
  end

  # Fix `clang++ -std=gnu++11` compile failure issue on macOS.
  patch :p0 do
    url "https:raw.githubusercontent.commacportsmacports-ports04ad4a17332e391cd359271965d4c6dac87a7eb2javaopenjdk8files0001-8181503-Can-t-compile-hotspot-with-c-11.patch"
    sha256 "a02e0ea7c70390796e46b8b6565f986fedc17a08aa039ee3306438a39a60538a"
  end
  patch :p0 do
    url "https:raw.githubusercontent.commacportsmacports-ports04ad4a17332e391cd359271965d4c6dac87a7eb2javaopenjdk8files0006-Disable-C-11-warnings.patch"
    sha256 "127d9508b72005e849a6ada6adf04bd49a236731d769810e67793bdf2aa722fe"
  end
  patch :p0, :DATA

  def install
    _, _, update = version.to_s.rpartition("-")
    boot_jdk = buildpath"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    java_options = ENV.delete("_JAVA_OPTIONS")

    # Work around clashing -Iusrinclude and -isystem headers, as superenv already handles this detail for us.
    inreplace "commonautoconfflags.m4",
              '-isysroot \"$SYSROOT\"', ""
    inreplace "commonautoconftoolchain.m4",
              '-isysroot \"$SDKPATH\" -iframework\"$SDKPATHSystemLibraryFrameworks\"', ""
    inreplace "hotspotmakebsdmakefilessaproc.make",
              '-isysroot "$(SDKPATH)" -iframework"$(SDKPATH)SystemLibraryFrameworks"', ""

    if OS.mac?
      # Fix macOS version detection. After 10.10 this was changed to a 6 digit number,
      # but this Makefile was written in the era of 4 digit numbers.
      inreplace "hotspotmakebsdmakefilesgcc.make" do |s|
        s.gsub! "$(subst .,,$(MACOSX_VERSION_MIN))", ENV["HOMEBREW_MACOS_VERSION_NUMERIC"]
        s.gsub! "MACOSX_VERSION_MIN=10.7.0", "MACOSX_VERSION_MIN=#{MacOS.version}"
      end
    else
      # Fix linker errors on brewed GCC.
      inreplace "commonautoconfflags.m4", "-Xlinker -O1", ""
      inreplace "hotspotmakelinuxmakefilesgcc.make", "-Xlinker -O1", ""
    end

    args = %W[
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-conf-name=release
      --with-jvm-variants=server
      --with-milestone=fcs
      --with-native-debug-symbols=none
      --with-update-version=#{update}
      --with-build-number=#{BUILD_NUMBER}
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-giflib=system
    ]

    ldflags = ["-Wl,-rpath,#{loader_path.gsub("$", "\\$$$$")}server"]
    if OS.mac?
      args += %w[
        --with-toolchain-type=clang
        --with-zlib=system
      ]

      extra_cflags = []
      extra_cxxflags = []

      # On macOS Sonoma or newer, we provide the missing JNF headers from an external resource.
      if MacOS.version >= :sonoma
        resource("JavaNativeFoundation").stage do
          jnf_headers = buildpath"jnf-headers"
          jnf_headers.install Pathname.pwd"appleJavaNativeFoundationJavaNativeFoundation"
          # Work around for missing 'JavaNativeFoundationJavaNativeFoundation.h' in MacosxDebuggerLocal.m.
          (buildpath"hotspotagentsrcosbsd").install_symlink jnf_headers
          # Add JNF headers to extra flags.
          extra_cflags << "-I#{jnf_headers}"
          extra_cxxflags << "-I#{jnf_headers}"
        end
      end

      # Work around Xcode 16 bug: https:bugs.openjdk.orgbrowseJDK-8340341.
      extra_cflags << "-mllvm -enable-constraint-elimination=0" if DevelopmentTools.clang_build_version == 1600

      args << "--with-extra-cflags=#{extra_cflags.join(" ")}" unless extra_cflags.empty?
      args << "--with-extra-cxxflags=#{extra_cxxflags.join(" ")}" unless extra_cxxflags.empty?
    else
      args += %W[
        --with-toolchain-type=gcc
        --x-includes=#{HOMEBREW_PREFIX}include
        --x-libraries=#{HOMEBREW_PREFIX}lib
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
        --with-stdc++lib=dynamic
      ]
      arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
      extra_rpath = rpath(source: libexec"lib"arch, target: libexec"jrelib"arch)
      ldflags << "-Wl,-rpath,#{extra_rpath.gsub("$", "\\$$$$")}"
    end
    args << "--with-extra-ldflags=#{ldflags.join(" ")}"

    system "bash", "commonautoconfautogen.sh"
    system "bash", "configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "bootcycle-images", "CONF=release"

    cd "buildreleaseimages" do
      jdk = libexec

      if OS.mac?
        libexec.install Dir["j2sdk-bundle*"].first => "openjdk.jdk"
        jdk = "openjdk.jdkContentsHome"
      else
        libexec.install Dir["j2sdk-image*"]
      end

      bin.install_symlink Dir[jdk"bin*"]
      include.install_symlink Dir[jdk"include*.h"]
      include.install_symlink Dir[jdk"include**.h"]
      man1.install_symlink Dir[jdk"manman1*"]
    end
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}openjdk.jdk LibraryJavaJavaVirtualMachinesopenjdk-8.jdk
      EOS
    end
  end

  test do
    (testpath"HelloWorld.java").write <<~JAVA
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    system bin"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}java HelloWorld")
  end
end

__END__
--- jdksrcsharebinsplashscreen_stubs.c
+++ jdksrcsharebinsplashscreen_stubs.c
@@ -61,11 +61,11 @@
 #define INVOKEV(name) _INVOKE(name, ,;)

 int     DoSplashLoadMemory(void* pdata, int size) {
-    INVOKE(SplashLoadMemory, NULL)(pdata, size);
+    INVOKE(SplashLoadMemory, 0)(pdata, size);
 }

 int     DoSplashLoadFile(const char* filename) {
-    INVOKE(SplashLoadFile, NULL)(filename);
+    INVOKE(SplashLoadFile, 0)(filename);
 }

 void    DoSplashInit(void) {

--- jdksrcsharenativecomsunjavautiljarpackjni.cpp
+++ jdksrcsharenativecomsunjavautiljarpackjni.cpp
@@ -292,7 +292,7 @@

   if (uPtr->aborting()) {
     THROW_IOE(uPtr->get_abort_message());
-    return false;
+    return 0;
   }

    We have fetched all the files.
--- jdksrcmacosxnativecomsunmediasoundPLATFORM_API_MacOSX_Ports.cpp
+++ jdksrcmacosxnativecomsunmediasoundPLATFORM_API_MacOSX_Ports.cpp
@@ -609,7 +609,7 @@
                  get the channel name
                 char *channelName;
                 CFStringRef cfname = NULL;
-                const AudioObjectPropertyAddress address = {kAudioObjectPropertyElementName, port->scope, ch};
+                const AudioObjectPropertyAddress address = {kAudioObjectPropertyElementName, port->scope, (unsigned)ch};
                 UInt32 size = sizeof(cfname);
                 OSStatus err = AudioObjectGetPropertyData(mixer->deviceID, &address, 0, NULL, &size, &cfname);
                 if (err == noErr) {