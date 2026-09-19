class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.org/"
  url "https://ghfast.top/https://github.com/openjdk/jdk27u/archive/refs/tags/jdk-27-ga.tar.gz"
  sha256 "7b0d39b840e008bd0a8e3d2c93d874d48536ec3e4c13045a7a83179042e2011e"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(\d+(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "db2b560ca59a2b2b8bf7e1bc900a80479d74c6c855dec497c9df2eeb5282790a"
    sha256 cellar: :any, arm64_tahoe:       "060b8fe0ebe12e885dccb992c063973018262defb1d3483939d5941fa5d00c9f"
    sha256 cellar: :any, arm64_sequoia:     "934cf2a836e98792d3a4c8f3a2cea90788b4cbc01958aa85c16cdd3609d34738"
    sha256               arm64_linux:       "cc7ba53035abcfaa0d525df2a334398713753520f91fd159c5c7c095db2f654c"
    sha256               x86_64_linux:      "71bcc4e1bec60bef2b495a95676c41002536aec8490a344fa074c5685ed2d4c6"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "unzip" => :build
  uses_from_macos "zip" => :build
  uses_from_macos "cups" => :no_linkage

  on_macos do
    depends_on xcode: :build # for metal
  end

  on_linux do
    depends_on "libxt" => :build
    depends_on "alsa-lib"
    depends_on "fontconfig" => :no_linkage
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr" => :no_linkage
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "zlib-ng-compat"
  end

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://download.java.net/java/GA/jdk26.0.2.1/3b8e6c7ec6274148a7aa15e7e7dfb53c/1/GPL/openjdk-26.0.2.1_macos-aarch64_bin.tar.gz"
        sha256 "3a61f9bbfbf2e09308aa4b1a5c044fcbc82f6ba49e074be49a7b7911e1f00efd"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk26.0.2.1/3b8e6c7ec6274148a7aa15e7e7dfb53c/1/GPL/openjdk-26.0.2.1_macos-x64_bin.tar.gz"
        sha256 "5ec3817530ffa1c38f15a55609a2767335bbd0c59ea8ce41aad68d3cd620c0ae"
      end
    end
    on_linux do
      on_arm do
        url "https://download.java.net/java/GA/jdk26.0.2.1/3b8e6c7ec6274148a7aa15e7e7dfb53c/1/GPL/openjdk-26.0.2.1_linux-aarch64_bin.tar.gz"
        sha256 "b96b265a4a1a36c02454148891aa58ca63303cbc2d1b7979c33b4fe99e09117b"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk26.0.2.1/3b8e6c7ec6274148a7aa15e7e7dfb53c/1/GPL/openjdk-26.0.2.1_linux-x64_bin.tar.gz"
        sha256 "a1489256029b389ce6ee52da0de1d01496c5df1776d6870241fe4823b998ea61"
      end
    end
  end

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
      --with-freetype=system
      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system
    ]

    ldflags = %W[
      -Wl,-rpath,#{loader_path.gsub("$", "\\$$")}
      -Wl,-rpath,#{loader_path.gsub("$", "\\$$")}/server
    ]
    args += if OS.mac?
      ldflags << "-headerpad_max_install_names"

      # Allow unbundling `freetype` on macOS
      inreplace "make/autoconf/lib-freetype.m4", '= "xmacosx"', '= ""'

      %W[
        --enable-dtrace
        --with-freetype-include=#{formula_opt_include("freetype")}
        --with-freetype-lib=#{formula_opt_lib("freetype")}
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
    (testpath/"HelloWorld.java").write <<~JAVA
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end