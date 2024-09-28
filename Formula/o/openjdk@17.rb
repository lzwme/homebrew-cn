class OpenjdkAT17 < Formula
  desc "Development kit for the Java programming language"
  homepage "https:openjdk.java.net"
  url "https:github.comopenjdkjdk17uarchiverefstagsjdk-17.0.12-ga.tar.gz"
  sha256 "74654bdd094c466217d3c65d71622f5ad9039d86d0c1b5eaa0bf6b2ae6e0822d"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(^jdk[._-]v?(17(?:\.\d+)*)-ga$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "2337b0a74e2ebf5d5960afb2da9abccfdf0454502687f31a1ea329c6fbf0e955"
    sha256 cellar: :any, arm64_sonoma:   "3b29caef76d813ed09ab21895f936d1cbfeaa82036cf2c11c60921edbb695a1a"
    sha256 cellar: :any, arm64_ventura:  "63c80057ba27ee109b7ae201ed1c636d96a4d7b70c51e5173d3b8d954c8e01fc"
    sha256 cellar: :any, arm64_monterey: "6fa7a88b24590d26454d2098d436593117bba45683cb54b32fa3ec0ed5bf63e4"
    sha256 cellar: :any, sonoma:         "e15a14c4af6f59721addd21288a9f8e767ae30021d2caec8fb4093ae84e5ada4"
    sha256 cellar: :any, ventura:        "17a2ee28099824bd37941ce63d80b068913999daa2010e332a04ee1aa6755bed"
    sha256 cellar: :any, monterey:       "c0057a4f9927733cc670444c0f2f4c9eab2ce51f21d2bca08cbc661c024299e0"
    sha256               x86_64_linux:   "ea8063d59d2c2d5a27d6355b2378840067418f0d92f061a891d2414e2a7cdf3a"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build # for metal

  depends_on "freetype"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_macos do
    if DevelopmentTools.clang_build_version == 1600
      depends_on "llvm" => :build

      fails_with :clang do
        cause "fatal error while optimizing exploded image for BUILD_JIGSAW_TOOLS"
      end
    end
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

  fails_with gcc: "5"

  # From https:jdk.java.netarchive
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https:download.java.netjavaGAjdk17.0.2dfd4a8d0985749f896bed50d7138ee7f8GPLopenjdk-17.0.2_macos-aarch64_bin.tar.gz"
        sha256 "602d7de72526368bb3f80d95c4427696ea639d2e0cc40455f53ff0bbb18c27c8"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk17.0.2dfd4a8d0985749f896bed50d7138ee7f8GPLopenjdk-17.0.2_macos-x64_bin.tar.gz"
        sha256 "b85c4aaf7b141825ad3a0ea34b965e45c15d5963677e9b27235aa05f65c6df06"
      end
    end
    on_linux do
      on_arm do
        url "https:download.java.netjavaGAjdk17.0.2dfd4a8d0985749f896bed50d7138ee7f8GPLopenjdk-17.0.2_linux-aarch64_bin.tar.gz"
        sha256 "13bfd976acf8803f862e82c7113fb0e9311ca5458b1decaef8a09ffd91119fa4"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk17.0.2dfd4a8d0985749f896bed50d7138ee7f8GPLopenjdk-17.0.2_linux-x64_bin.tar.gz"
        sha256 "0022753d0cceecacdd3a795dd4cea2bd7ffdf9dc06e22ffd1be98411742fbb44"
      end
    end
  end

  def install
    if DevelopmentTools.clang_build_version == 1600
      ENV.llvm_clang
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
      # ptrauth.h is not available in brew LLVM
      inreplace "srchotspotos_cpubsd_aarch64pauth_bsd_aarch64.inline.hpp" do |s|
        s.sub! "#include <ptrauth.h>", ""
        s.sub! "return ptrauth_strip(ptr, ptrauth_key_asib);", "return ptr;"
      end
    end

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
      --with-freetype=system
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

      # Allow unbundling `freetype` on macOS
      inreplace "makeautoconflib-freetype.m4", '= "xmacosx"', '= ""'

      %W[
        --enable-dtrace
        --with-freetype-include=#{Formula["freetype"].opt_include}
        --with-freetype-lib=#{Formula["freetype"].opt_lib}
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
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
          sudo ln -sfn #{opt_libexec}openjdk.jdk LibraryJavaJavaVirtualMachinesopenjdk-17.jdk
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