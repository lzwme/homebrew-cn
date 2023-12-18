class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https:openjdk.java.net"
  url "https:github.comopenjdkjdk21uarchiverefstagsjdk-21.0.1-ga.tar.gz"
  sha256 "4414ebc898e53489c2325ff6cb1a73640840f31c2fd671bd598e23c8a87e88ad"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(^jdk[._-]v?(\d+(?:\.\d+)*)-ga$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8434ad4d2e79651c391fde1ef01214306472efbec91586314a85c02bd72fc2cb"
    sha256 cellar: :any, arm64_ventura:  "b0223e230b1086a6dab7c00472fac8ef67f799bf570a8f1b38e6844f9c224368"
    sha256 cellar: :any, arm64_monterey: "cd6a8ae3e2b9c3edcbb41a91086e7b9eba56f43e4c2df0129da940eb6f7de92c"
    sha256 cellar: :any, sonoma:         "ab5d32ae29ea72e85d1169d4c34cdf6faaf96c7859f51bcb98305efd89c9602c"
    sha256 cellar: :any, ventura:        "1b4756f75bd4f3050d72c6edfcc3d67da764526cc66cae6ed021b8cb41c6b1aa"
    sha256 cellar: :any, monterey:       "28ffa2b1363d45e92a5bd425a8fd3ec77696b3a859f63dd61c15a149690b54bf"
    sha256               x86_64_linux:   "90f191bb2d7a118a3509df17eddcad6ec3be26a13064b10145a26c7de1578733"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"
  depends_on macos: :catalina

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
  end

  fails_with gcc: "5"

  # From https:jdk.java.netarchive
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https:download.java.netjavaGAjdk20.0.26e380f22cbe7469fa75fb448bd903d8e9GPLopenjdk-20.0.2_macos-aarch64_bin.tar.gz"
        sha256 "2e6522bb574f76cd3f81156acd59115a014bf452bbe4107f0d31ff9b41b3da57"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk20.0.26e380f22cbe7469fa75fb448bd903d8e9GPLopenjdk-20.0.2_macos-x64_bin.tar.gz"
        sha256 "c65ba92b73d8076e2a10029a0674d40ce45c3e0183a8063dd51281e92c9f43fc"
      end
    end
    on_linux do
      on_arm do
        url "https:download.java.netjavaGAjdk20.0.26e380f22cbe7469fa75fb448bd903d8e9GPLopenjdk-20.0.2_linux-aarch64_bin.tar.gz"
        sha256 "3238c93267c663dbca00f5d5b0e3fbba40e1eea2b4281612f40542d208b6dd9a"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk20.0.26e380f22cbe7469fa75fb448bd903d8e9GPLopenjdk-20.0.2_linux-x64_bin.tar.gz"
        sha256 "beaf61959c2953310595e1162b0c626aef33d58628771033ff2936609661956c"
      end
    end
  end

  # Patch to restore build on macOS 13
  patch :DATA

  def install
    boot_jdk = buildpath"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk = "ContentsHome" if OS.mac?
    java_options = ENV.delete("_JAVA_OPTIONS")

    args = %W[
      --disable-warnings-as-errors
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-jvm-variants=server
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-version-build=#{revision}
      --without-version-opt
      --without-version-pre
      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system
    ]

    ldflags = ["-Wl,-rpath,#{loader_path.gsub("$", "\\$$")}server"]
    args += if OS.mac?
      ldflags << "-headerpad_max_install_names"

      %W[
        --enable-dtrace
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
        --with-freetype=system
        --with-stdc++lib=dynamic
      ]
    end
    args << "--with-extra-ldflags=#{ldflags.join(" ")}"

    system "bash", "configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    jdk = libexec
    if OS.mac?
      libexec.install Dir["build*imagesjdk-bundle*"].first => "openjdk.jdk"
      jdk = "openjdk.jdkContentsHome"
    else
      libexec.install Dir["buildlinux-*-server-releaseimagesjdk*"]
    end

    bin.install_symlink Dir[jdk"bin*"]
    include.install_symlink Dir[jdk"include*.h"]
    include.install_symlink Dir[jdk"include"OS.kernel_name.downcase"*.h"]
    man1.install_symlink Dir[jdk"manman1*"]
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}openjdk.jdk LibraryJavaJavaVirtualMachinesopenjdk.jdk
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
diff -pur asrcjdk.netmacosxnativelibextnetMacOSXSocketOptions.c bsrcjdk.netmacosxnativelibextnetMacOSXSocketOptions.c
--- asrcjdk.netmacosxnativelibextnetMacOSXSocketOptions.c	2022-08-12 22:24:53.000000000 +0200
+++ bsrcjdk.netmacosxnativelibextnetMacOSXSocketOptions.c	2022-10-24 18:27:36.000000000 +0200
@@ -29,9 +29,9 @@
 #include <unistd.h>
 
 #include <jni.h>
-#include <netinettcp.h>
 
 #define __APPLE_USE_RFC_3542
+#include <netinettcp.h>
 #include <netinetin.h>
 
 #ifndef IP_DONTFRAG