class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://ghproxy.com/https://github.com/openjdk/jdk20u/archive/refs/tags/jdk-20.0.2-ga.tar.gz"
  sha256 "359fbcdb5bb2645f9dcc65072b62cb646498e95643774ebca2fcbf599f73f79e"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(\d+(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "7c023f8b5172370350f8eef5a5363f5225be4d75003cfe1ef25e729aa474a4dc"
    sha256 cellar: :any, arm64_monterey: "563bd49837bbdb636c072bfe81257d825b0a418dbfe120bef5b3ed6ea88345e5"
    sha256 cellar: :any, arm64_big_sur:  "56de3d53e9b83b4731d8decc25087ba5df3c513ba8728759dfb776ec2ab8fb1a"
    sha256 cellar: :any, ventura:        "00801f056fbce3480637acdf48b4aaffd977e38450f83b72c2954b48c329153b"
    sha256 cellar: :any, monterey:       "214cffc504d48ca3e369ec32b7c75e3bf3795d819ea8939cbe2b380f003cf924"
    sha256 cellar: :any, big_sur:        "f9f580b472e91bdc818df43c7384088b6235ce6b900850d5a7b962a52869b4a0"
    sha256               x86_64_linux:   "1db7667c3af7a5c4cee3ebe058b620f908afa23eb3a646f7b1a96a8254386d69"
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

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://download.java.net/java/GA/jdk19.0.1/afdd2e245b014143b62ccb916125e3ce/10/GPL/openjdk-19.0.1_macos-aarch64_bin.tar.gz"
        sha256 "915054b18fc17216410cea7aba2321c55b82bd414e1ef3c7e1bafc7beb6856c8"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk19.0.1/afdd2e245b014143b62ccb916125e3ce/10/GPL/openjdk-19.0.1_macos-x64_bin.tar.gz"
        sha256 "469af195906979f96c1dc862c2f539a5e280d0daece493a95ebeb91962512161"
      end
    end
    on_linux do
      on_arm do
        url "https://download.java.net/java/GA/jdk19.0.1/afdd2e245b014143b62ccb916125e3ce/10/GPL/openjdk-19.0.1_linux-aarch64_bin.tar.gz"
        sha256 "88cadc91d5c7c540ea9df5d23678bb65dc2092fe4e00650b39d87f24f2328e17"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk19.0.1/afdd2e245b014143b62ccb916125e3ce/10/GPL/openjdk-19.0.1_linux-x64_bin.tar.gz"
        sha256 "7a466882c7adfa369319fe4adeb197ee5d7f79e75d641e9ef94abee1fc22b1fa"
      end
    end
  end

  # Patch to restore build on macOS 13
  patch :DATA

  def install
    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac?
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

    ldflags = ["-Wl,-rpath,#{loader_path.gsub("$", "\\$$")}/server"]
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
      libexec.install Dir["build/*/images/jdk-bundle/*"].first => "openjdk.jdk"
      jdk /= "openjdk.jdk/Contents/Home"
    else
      libexec.install Dir["build/linux-*-server-release/images/jdk/*"]
    end

    bin.install_symlink Dir[jdk/"bin/*"]
    include.install_symlink Dir[jdk/"include/*.h"]
    include.install_symlink Dir[jdk/"include"/OS.kernel_name.downcase/"*.h"]
    man1.install_symlink Dir[jdk/"man/man1/*"]
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
      EOS
    end
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end

__END__
diff -pur a/src/jdk.net/macosx/native/libextnet/MacOSXSocketOptions.c b/src/jdk.net/macosx/native/libextnet/MacOSXSocketOptions.c
--- a/src/jdk.net/macosx/native/libextnet/MacOSXSocketOptions.c	2022-08-12 22:24:53.000000000 +0200
+++ b/src/jdk.net/macosx/native/libextnet/MacOSXSocketOptions.c	2022-10-24 18:27:36.000000000 +0200
@@ -29,9 +29,9 @@
 #include <unistd.h>
 
 #include <jni.h>
-#include <netinet/tcp.h>
 
 #define __APPLE_USE_RFC_3542
+#include <netinet/tcp.h>
 #include <netinet/in.h>
 
 #ifndef IP_DONTFRAG