class OpenjdkAT21 < Formula
  desc "Development kit for the Java programming language"
  homepage "https:openjdk.java.net"
  url "https:github.comopenjdkjdk21uarchiverefstagsjdk-21.0.2-ga.tar.gz"
  sha256 "17eda717843ffbbacc7de4bdcd934f404a23a57ebb3cda3cec630a668651531f"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(^jdk[._-]v?(21+(?:\.\d+)*)-ga$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9a47d5fa08dd6cf6a68ea44cf52e34ce45838927060ea470b3772fe7e210dd8f"
    sha256 cellar: :any, arm64_ventura:  "8e8d2c411193fcd13f2ce05d37e377582d06e1ce7bc1b797918fd650bf51dc5b"
    sha256 cellar: :any, arm64_monterey: "8ef0cb75011a9028acc124906a7561856481e96b3000a371b27179fcae386dcb"
    sha256 cellar: :any, sonoma:         "cf7e20bebe3d0e0d5435bae4fdb09e3739c6349fc438a46e97293edd74b11678"
    sha256 cellar: :any, ventura:        "c160c242dfa792ddb6cdfaaa555b77461a3fdf435fdcc9bdd8b3ab96c078e109"
    sha256 cellar: :any, monterey:       "dee3491fd650e010d8a02ef63ede76db26dc3a06fc232e9e08c14c11b68a2168"
    sha256               x86_64_linux:   "db0b039ffb1accf89552864287bb0e4466d356e0d5f031d8dfb23f8d0ee2d668"
  end

  keg_only :versioned_formula

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
        url "https:download.java.netjavaGAjdk21.0.1415e3f918a1f4062a0074a2794853d0d12GPLopenjdk-21.0.1_macos-aarch64_bin.tar.gz"
        sha256 "9760eaa019b6d214a06bd44a304f3700ac057d025000bdfb9739b61080969a96"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk21.0.1415e3f918a1f4062a0074a2794853d0d12GPLopenjdk-21.0.1_macos-x64_bin.tar.gz"
        sha256 "1ca6db9e6c09752f842eee6b86a2f7e51b76ae38e007e936b9382b4c3134e9ea"
      end
    end
    on_linux do
      on_arm do
        url "https:download.java.netjavaGAjdk21.0.1415e3f918a1f4062a0074a2794853d0d12GPLopenjdk-21.0.1_linux-aarch64_bin.tar.gz"
        sha256 "f5e4e4622756fafe05ac0105a8efefa1152c8aad085a2bbb9466df0721bf2ba4"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk21.0.1415e3f918a1f4062a0074a2794853d0d12GPLopenjdk-21.0.1_linux-x64_bin.tar.gz"
        sha256 "7e80146b2c3f719bf7f56992eb268ad466f8854d5d6ae11805784608e458343f"
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
          sudo ln -sfn #{opt_libexec}openjdk.jdk LibraryJavaJavaVirtualMachinesopenjdk-21.jdk
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