class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https:openjdk.java.net"
  url "https:github.comopenjdkjdk11uarchiverefstagsjdk-11.0.21-ga.tar.gz"
  sha256 "b89e87c38640c586857ae6108b3f9c3211337e4cd5d8913c8d56d66bdccab014"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^jdk[._-]v?(11(?:\.\d+)*)-ga$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "864a430986f5a86ee8bd94418c1b0a8a67607f08bf102332c0b44d8f946d8d3d"
    sha256 cellar: :any,                 arm64_ventura:  "1404392483f129c665506bb5e29c89a25224ebb5c93481be79399f6814ed08a4"
    sha256 cellar: :any,                 arm64_monterey: "2ca235af0d2c4da35617a958d5027e9aa97b9862e46382b6e0c9625563b64a3d"
    sha256 cellar: :any,                 sonoma:         "d46b722959772560c33194d83ff38a9a8dc5d2c537506a70eb2c34cbc6888052"
    sha256 cellar: :any,                 ventura:        "68d7d06e6fb05e4672573190f761131693ca29dae179e4f3b341420fe0b65073"
    sha256 cellar: :any,                 monterey:       "1a94657463a47c7dd17bdc732d7748994ce9f6749c4f3ece01d6178c7d735266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0235a9aa57f27553c0838c430f12b26cc672c8f8da950cfb5a2bbe3fc7388b"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

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

  # ARM64: https:www.azul.comdownloads?version=java-11-lts&package=jdk
  # Intel: https:jdk.java.netarchive
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https:cdn.azul.comzulubinzulu11.62.17-ca-jdk11.0.18-macosx_aarch64.tar.gz"
        sha256 "2a3f56af83f9d180dfce5d6e771a292bbbd68a77c7c18ed3bdb607e86d773704"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk119GPLopenjdk-11.0.2_osx-x64_bin.tar.gz"
        sha256 "f365750d4be6111be8a62feda24e265d97536712bc51783162982b8ad96a70ee"
      end
    end
    on_linux do
      on_arm do
        url "https:cdn.azul.comzulu-embeddedbinzulu11.62.17-ca-jdk11.0.18-linux_aarch64.tar.gz"
        sha256 "9f5ac83b584a297c792cc5feb67c752a2d9fc1259abec3a477e96be8b672f452"
      end
      on_intel do
        url "https:download.java.netjavaGAjdk119GPLopenjdk-11.0.2_linux-x64_bin.tar.gz"
        sha256 "99be79935354f5c0df1ad293620ea36d13f48ec3ea870c838f20c504c9668b57"
      end
    end
  end

  def install
    boot_jdk = buildpath"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk = "ContentsHome" if OS.mac? && !Hardware::CPU.arm?
    java_options = ENV.delete("_JAVA_OPTIONS")

    args = %W[
      --disable-hotspot-gtest
      --disable-warnings-as-errors
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-conf-name=release
      --with-jvm-variants=server
      --with-jvm-features=shenandoahgc
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
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
    system "make", "images", "CONF=release"

    cd "buildreleaseimages" do
      jdk = libexec
      if OS.mac?
        libexec.install Dir["jdk-bundle*"].first => "openjdk.jdk"
        jdk = "openjdk.jdkContentsHome"
      else
        libexec.install Dir["jdk*"]
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
          sudo ln -sfn #{opt_libexec}openjdk.jdk LibraryJavaJavaVirtualMachinesopenjdk-11.jdk
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