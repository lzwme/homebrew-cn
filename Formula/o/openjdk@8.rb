class OpenjdkAT8 < Formula
  desc "Development kit for the Java programming language"
  homepage "https:openjdk.java.net"
  url "https:github.comopenjdkjdk8uarchiverefstagsjdk8u402-ga.tar.gz"
  version "1.8.0-402"
  sha256 "4e7495914ca02ef8e3d467d0026ff76672891b4ba026b4200aeb9a0666e22238"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^jdk(8u\d+)-ga$i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub("8u", "1.8.0+") }
    end
  end

  bottle do
    sha256 cellar: :any,                 sonoma:       "1e901572b4fce1133d8756af7a6c8d5c33e6b149e380c8522f0007bc0b1afe21"
    sha256 cellar: :any,                 ventura:      "d2305fca54292a5152ca641221b39377b0a52ff86c74d9720eac6b5e930e8f8f"
    sha256 cellar: :any,                 monterey:     "7fcaf5b6bf40ba8cb74efbc894894bf2e7f0dea1a0bef624dc854f00316ef3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "237c6366e97df8e42427ff80f49bc7c2e02754f32baf609011397e9d79d625f3"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "freetype"
  depends_on "giflib"

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_monterey :or_newer do
    depends_on "gawk" => :build
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
  end

  # Oracle doesn't serve JDK 7 downloads anymore, so we use Zulu JDK 7 for bootstrapping.
  # https:www.azul.comdownloads?version=java-7-lts&package=jdk
  resource "boot-jdk" do
    on_macos do
      url "https:cdn.azul.comzulubinzulu7.56.0.11-ca-jdk7.0.352-macosx_x64.tar.gz"
      sha256 "31909aa6233289f8f1d015586825587e95658ef59b632665e1e49fc33a2cdf06"
    end
    on_linux do
      url "https:cdn.azul.comzulubinzulu7.56.0.11-ca-jdk7.0.352-linux_x64.tar.gz"
      sha256 "8a7387c1ed151474301b6553c6046f865dc6c1e1890bcf106acc2780c55727c8"
    end
  end

  # Fix `clang++ -std=gnu++11` compile failure issue on MacOS.
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

    # Work around clashing -Iusrinclude and -isystem headers,
    # as superenv already handles this detail for us.
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

      # Fix Xcode 13 detection.
      inreplace "commonautoconftoolchain.m4",
                "if test \"${XC_VERSION_PARTS[[0]]}\" != \"6\"",
                "if test \"${XC_VERSION_PARTS[[0]]}\" != \"#{MacOS::Xcode.version.major}\""
    else
      # Fix linker errors on brewed GCC
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

      # Work around SDK issues with JavaVM framework.
      if MacOS.version <= :catalina
        sdk_path = MacOS::CLT.sdk_path(MacOS.version)
        ENV["SDKPATH"] = ENV["SDKROOT"] = sdk_path
        javavm_framework_path = sdk_path"SystemLibraryFrameworksJavaVM.frameworkFrameworks"
        args += %W[
          --with-extra-cflags=-F#{javavm_framework_path}
          --with-extra-cxxflags=-F#{javavm_framework_path}
        ]
        ldflags << "-F#{javavm_framework_path}"
        # Fix "'JavaNativeFoundationJavaNativeFoundation.h' file not found" issue on MacOS Sonoma.
      elsif MacOS.version == :sonoma
        javavm_framework_path = "LibraryDeveloperCommandLineToolsSDKsMacOSX13.sdkSystemLibraryFrameworks"
        args += %W[
          --with-extra-cflags=-F#{javavm_framework_path}
          --with-extra-cxxflags=-F#{javavm_framework_path}
        ]
        ldflags << "-F#{javavm_framework_path}"
      end
    else
      args += %W[
        --with-toolchain-type=gcc
        --x-includes=#{HOMEBREW_PREFIX}include
        --x-libraries=#{HOMEBREW_PREFIX}lib
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
        --with-stdc++lib=dynamic
      ]
      extra_rpath = rpath(source: libexec"libamd64", target: libexec"jrelibamd64")
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
    (testpath"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}java HelloWorld")
  end
end

__END__
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