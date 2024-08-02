class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https:freeswitch.org"
  url "https:github.comsignalwirefreeswitch.git",
      tag:      "v1.10.11",
      revision: "f24064f7c9c2b939226712d3f498c17931386589"
  license "MPL-1.1"
  head "https:github.comsignalwirefreeswitch.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "5f5a55112d7509527b58ec43f411b2b49404c75326a5f07bf30df2ff64174eee"
    sha256 arm64_ventura:  "95c01107a57d819adf1c81676524ec20df183f73a472a98d59a6185de4ecd778"
    sha256 arm64_monterey: "27969c912231d980949199c808802862eabe8436d333c6e230a4b8e4ae96d06f"
    sha256 sonoma:         "9246ede909150a14667313303dac648c61d92eebcc1fcd8c99140b70ce7a2d46"
    sha256 ventura:        "b6db797dd08da428b05dbf46a9e6024a4db4c472458c64542f239bc1f1c539ac"
    sha256 monterey:       "741226120d276d65dccff276f22e870a86a437656b01e5855e3f7444f4333c51"
    sha256 x86_64_linux:   "6ee86164192248603b7d411a44fdd6bb9392f9bf30361905a1f81049684f2300"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg@5" # FFmpeg 6 issue: https:github.comsignalwirefreeswitchissues2202
  depends_on "jpeg-turbo"
  depends_on "ldns"
  depends_on "libpq"
  depends_on "libsndfile"
  depends_on "libtiff"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pcre" # PCRE2 PR: https:github.comsignalwirefreeswitchpull2299
  depends_on "sofia-sip"
  depends_on "speex"
  depends_on "speexdsp"
  depends_on "sqlite"
  depends_on "util-linux"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  # https:github.comHomebrewhomebrewissues42865

  #----------------------- Begin sound file resources -------------------------
  sounds_url_base = "https:files.freeswitch.orgreleasessounds"

  #---------------
  # music on hold
  #---------------
  moh_version = "1.0.52" # from buildmoh_version.txt
  resource "sounds-music-8000" do
    url "#{sounds_url_base}freeswitch-sounds-music-8000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "2491dcb92a69c629b03ea070d2483908a52e2c530dd77791f49a45a4d70aaa07"
  end
  resource "sounds-music-16000" do
    url "#{sounds_url_base}freeswitch-sounds-music-16000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "93e0bf31797f4847dc19a94605c039ad4f0763616b6d819f5bddbfb6dd09718a"
  end
  resource "sounds-music-32000" do
    url "#{sounds_url_base}freeswitch-sounds-music-32000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "4129788a638b77c5f85ff35abfcd69793d8aeb9d7833a75c74ec77355b2657a9"
  end
  resource "sounds-music-48000" do
    url "#{sounds_url_base}freeswitch-sounds-music-48000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "cc31cdb5b1bd653850bf6e054d963314bcf7c1706a9bf05f5a69bcbd00858d2a"
  end

  #-----------
  # sounds-en
  #-----------
  sounds_en_version = "1.0.53" # from buildsounds_version.txt
  resource "sounds-en-us-callie-8000" do
    url "#{sounds_url_base}freeswitch-sounds-en-us-callie-8000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "24a2baad88696169950c84cafc236124b2bfa63114c7c8ac7d330fd980c8db05"
  end
  resource "sounds-en-us-callie-16000" do
    url "#{sounds_url_base}freeswitch-sounds-en-us-callie-16000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "3540235ed8ed86a3ec97d98225940f4c6bc665f917da4b3f2e1ddf99fc41cdea"
  end
  resource "sounds-en-us-callie-32000" do
    url "#{sounds_url_base}freeswitch-sounds-en-us-callie-32000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "6f5a572f9c3ee1a035b9b72673ffd9db57a345ce0d4fb9f85167f63ac7ec386a"
  end
  resource "sounds-en-us-callie-48000" do
    url "#{sounds_url_base}freeswitch-sounds-en-us-callie-48000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "980591a853fbf763818eb77132ea7e3ed876f8c4701e85070d612e1ebba09ae9"
  end

  #------------------------ End sound file resources --------------------------

  # There's no tags for now https:github.comfreeswitchspandspissues13
  resource "spandsp" do
    url "https:github.comfreeswitchspandsp.git",
        revision: "67d2455efe02e7ff0d897f3fd5636fed4d54549e"
  end

  resource "libks" do
    url "https:github.comsignalwirelibks.git",
        tag:      "v2.0.2",
        revision: "423c68c92d1871e2c9cb83d974eac7830ddcdcf5"
  end

  resource "signalwire-c" do
    url "https:github.comsignalwiresignalwire-c.git",
        tag:      "v2.0.0",
        revision: "c432105788424d1ddb7c59aacd49e9bfa3c5e917"
  end

  def install
    resource("spandsp").stage do
      system ".bootstrap.sh"
      system ".configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}spandsp"
      system "make"
      ENV.deparallelize { system "make", "install" }

      ENV.append_path "PKG_CONFIG_PATH", libexec"spandsplibpkgconfig"
    end

    resource("libks").stage do
      system "cmake", ".", *std_cmake_args(install_prefix: libexec"libks")
      system "cmake", "--build", "."
      system "cmake", "--install", "."

      ENV.append_path "PKG_CONFIG_PATH", libexec"libkslibpkgconfig"
      ENV.append "CFLAGS", "-I#{libexec}libksinclude"

      # Add RPATH to libks2.pc so libks2.so can be found by freeswitch modules.
      inreplace libexec"libkslibpkgconfiglibks2.pc",
                "-L${libdir}",
                "-Wl,-rpath,${libdir} -L${libdir}"
    end

    resource("signalwire-c").stage do
      system "cmake", ".", *std_cmake_args(install_prefix: libexec"signalwire-c")
      system "cmake", "--build", "."
      system "cmake", "--install", "."

      ENV.append_path "PKG_CONFIG_PATH", libexec"signalwire-clibpkgconfig"

      # Add RPATH to signalwire_client2.pc so libsignalwire_client2.so
      # can be found by freeswitch modules.
      inreplace libexec"signalwire-clibpkgconfigsignalwire_client2.pc",
                "-L${libdir}",
                "-Wl,-rpath,${libdir} -L${libdir}"
    end

    system ".bootstrap.sh", "-j"

    args = %W[
      --enable-shared
      --enable-static
      --exec_prefix=#{prefix}
    ]
    # Fails on ARM: https:github.comsignalwirefreeswitchissues1450
    args << "--disable-libvpx" if Hardware::CPU.arm?

    ENV.append_to_cflags "-D_ANSI_SOURCE" if OS.linux?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system ".configure", *std_configure_args, *args
    system "make", "all"
    system "make", "install"

    # Should be equivalent to: system "make", "cd-moh-install"
    mkdir_p pkgshare"soundsmusic"
    [8, 16, 32, 48].each do |n|
      resource("sounds-music-#{n}000").stage do
        cp_r ".", pkgshare"soundsmusic"
      end
    end

    # Should be equivalent to: system "make", "cd-sounds-install"
    mkdir_p pkgshare"soundsen"
    [8, 16, 32, 48].each do |n|
      resource("sounds-en-us-callie-#{n}000").stage do
        cp_r ".", pkgshare"soundsen"
      end
    end
  end

  service do
    run [opt_bin"freeswitch", "-nc", "-nonat"]
    keep_alive true
  end

  test do
    system bin"freeswitch", "-version"
  end
end