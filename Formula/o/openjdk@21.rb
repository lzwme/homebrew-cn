class OpenjdkAT21 < Formula
  desc "Development kit for the Java programming language"
  homepage "https:openjdk.java.net"
  url "https:github.comopenjdkjdk21uarchiverefstagsjdk-21.0.5-ga.tar.gz"
  sha256 "1dcf54fe0d4263a0fb95290a77dac9e4ff81761ed234daadfbab781f1779bf0b"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(^jdk[._-]v?(21(?:\.\d+)*)-ga$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "39d28c673b18915e808e38559a9bcfc272c947c475a2f9b36d3064d1b00833b3"
    sha256 cellar: :any, arm64_sonoma:  "0d39ee370b9230c65078039b9541c230aa86b0edc0f8c1bb564bc1fdf322ec11"
    sha256 cellar: :any, arm64_ventura: "48154af73a12195490174518372f7782d37634d7a16959d74f5802655372473b"
    sha256 cellar: :any, sonoma:        "1f6b28a4ce616c847f4b6360ccc4632a3862ca8e6bca32032a5daa7b50708a7e"
    sha256 cellar: :any, ventura:       "9631253796a0f5660e9685c96081b60ac7bcf6865df52dd6a3bd8596e7cb6359"
    sha256               x86_64_linux:  "63897ad3699f4111e6706068268e3088b38b14c574bd604d1d3176d7878adf9b"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build # for metal
  depends_on "freetype"
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
        url "https:download.java.netjavaGAjdk21.0.2f2283984656d49d69e91c558476027ac13GPLopenjdk-21.0.2_macos-aarch64_bin.tar.gz"
        sha256 "b3d588e16ec1e0ef9805d8a696591bd518a5cea62567da8f53b5ce32d11d22e4"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk21.0.2f2283984656d49d69e91c558476027ac13GPLopenjdk-21.0.2_macos-x64_bin.tar.gz"
        sha256 "8fd09e15dc406387a0aba70bf5d99692874e999bf9cd9208b452b5d76ac922d3"
      end
    end
    on_linux do
      on_arm do
        url "https:download.java.netjavaGAjdk21.0.2f2283984656d49d69e91c558476027ac13GPLopenjdk-21.0.2_linux-aarch64_bin.tar.gz"
        sha256 "08db1392a48d4eb5ea5315cf8f18b89dbaf36cda663ba882cf03c704c9257ec2"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk21.0.2f2283984656d49d69e91c558476027ac13GPLopenjdk-21.0.2_linux-x64_bin.tar.gz"
        sha256 "a2def047a73941e01a73739f92755f86b895811afb1f91243db214cff5bdac3f"
      end
    end
  end

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

    if DevelopmentTools.clang_build_version == 1600
      args << "--with-extra-cflags=-mllvm -enable-constraint-elimination=0"
    end

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
          sudo ln -sfn #{opt_libexec}openjdk.jdk LibraryJavaJavaVirtualMachinesopenjdk-21.jdk
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