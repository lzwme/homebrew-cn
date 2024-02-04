class Csound < Formula
  desc "Sound and music computing system"
  homepage "https:csound.com"
  url "https:github.comcsoundcsound.git",
      tag:      "6.18.1",
      revision: "a1580f9cdf331c35dceb486f4231871ce0b00266"
  license "LGPL-2.1-or-later"
  revision 6
  head "https:github.comcsoundcsound.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "d1f88292fe0dd20cc95853951e4d27ac5adc9a98862d17acb35d73b6914cd2d4"
    sha256 arm64_ventura:  "eedb8b6d2d423962e72ee82441553308ab4dd9411dca551f00020a86e34edcde"
    sha256 arm64_monterey: "0678817eca926f66a991fdc052389e0654508906a3e9adfddab3a33c470d7eba"
    sha256 sonoma:         "61d7120a629b1944136f5c08e9d9ba662ed3882b721c05cb10bb50b0952c3489"
    sha256 ventura:        "ba33e66857dea3dc9755b340f5932d5a66cdea930dd2790773b53d848a71c1b6"
    sha256 monterey:       "d03d0052525a882c6d697ecad22345352b675a588d187c70e499a1c0b083760b"
    sha256 x86_64_linux:   "4e7afc503eb1c7b60df58129e16113b221ebf63f4239933fb64c69b60ad8424f"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "swig" => :build
  depends_on "faust"
  depends_on "fltk"
  depends_on "fluid-synth"
  depends_on "gettext"
  depends_on "hdf5"
  depends_on "jack"
  depends_on "lame"
  depends_on "liblo"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libwebsockets"
  depends_on "numpy"
  depends_on "openjdk"
  depends_on "openssl@3"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "python@3.12"
  depends_on "stk"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "wiiuse"
  end

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "libextractor", because: "both install `extract` binaries"
  conflicts_with "pkcrack", because: "both install `extract` binaries"

  fails_with gcc: "5"

  resource "ableton-link" do
    url "https:github.comAbletonlinkarchiverefstagsLink-3.1.1.tar.gz"
    sha256 "90f9c8bd6526776235dc36dec71620ea82dbd89761294b6270595335cd2e2078"
  end

  resource "csound-plugins" do
    url "https:github.comcsoundpluginsarchiverefstags1.0.2.tar.gz"
    sha256 "8c2f0625ad1d38400030f414b92d82cfdec5c04b7dc178852f3e1935abf75d30"

    # Fix build on macOS 12.3+ by replacing old system PythonPython.h with Homebrew's Python.h
    patch do
      url "https:github.comcsoundpluginscommit13800c4dd58e3c214e5d7207180ad7115b4e2f27.patch?full_index=1"
      sha256 "e088cc300845408f3956f070fa34a900b700c7860678bc6d37f7506d615787a6"
    end
  end

  resource "getfem" do
    url "https:download.savannah.gnu.orgreleasesgetfemstablegetfem-5.4.2.tar.gz"
    sha256 "80b625d5892fe9959c3b316340f326e3ece4e98325eb0a81dd5b9ddae563b1d1"
  end

  def python3
    which("python3.12")
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    site_packages = prefixLanguage::Python.site_packages(python3)
    rpaths = [rpath]
    rpaths << rpath(target: frameworks) if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DBUILD_JAVA_INTERFACE=ON",
                    "-DBUILD_LUA_INTERFACE=OFF",
                    "-DBUILD_TESTS=OFF",
                    "-DCS_FRAMEWORK_DEST=#{frameworks}",
                    "-DJAVA_MODULE_INSTALL_DIR=#{libexec}",
                    "-DPYTHON3_MODULE_INSTALL_DIR=#{site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      include.install_symlink frameworks"CsoundLib64.frameworkHeaders" => "csound"
      site_packages.install buildpath"interfacesctcsound.py"
    else
      # On Linux, csound depends on binutils, but both formulae install `srconv` binaries
      (bin"srconv").unlink
    end

    resource("csound-plugins").stage do
      resource("ableton-link").stage buildpath"ableton-link"
      resource("getfem").stage { cp_r "srcgmm", buildpath }

      args = %W[
        -DABLETON_LINK_HOME=#{buildpath}ableton-link
        -DBUILD_ABLETON_LINK_OPCODES=ON
        -DBUILD_CHUA_OPCODES=ON
        -DBUILD_CUDA_OPCODES=OFF
        -DBUILD_FAUST_OPCODES=ON
        -DBUILD_FLUID_OPCODES=ON
        -DBUILD_HDF5_OPCODES=ON
        -DBUILD_IMAGE_OPCODES=ON
        -DBUILD_JACK_OPCODES=ON
        -DBUILD_LINEAR_ALGEBRA_OPCODES=ON
        -DBUILD_MP3OUT_OPCODE=ON
        -DBUILD_OPENCL_OPCODES=OFF
        -DBUILD_PYTHON_OPCODES=ON
        -DBUILD_STK_OPCODES=ON
        -DBUILD_WEBSOCKET_OPCODE=ON
        -DGMM_INCLUDE_DIR=#{buildpath}
        -DPython3_EXECUTABLE=#{python3}
        -DUSE_FLTK=ON
      ]
      args += if OS.mac?
        %W[
          -DBUILD_P5GLOVE_OPCODES=ON
          -DBUILD_WIIMOTE_OPCODES=ON
          -DCSOUND_FRAMEWORK=#{frameworks}CsoundLib64.framework
          -DCSOUND_INCLUDE_DIR=#{frameworks}CsoundLib64.frameworkHeaders
          -DPLUGIN_INSTALL_DIR=#{frameworks}CsoundLib64.frameworkResourcesOpcodes64
        ]
      else
        %w[
          -DBUILD_P5GLOVE_OPCODES=OFF
          -DBUILD_WIIMOTE_OPCODES=OFF
        ]
      end

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  def caveats
    caveats = <<~EOS
      To use the Java bindings, you may need to add to your shell profile
      e.g. ~.profile or ~.zshrc:
        export CLASSPATH="#{opt_libexec}csnd6.jar:."
      and link the native shared library into your Java Extensions folder:
    EOS

    on_macos do
      caveats = <<~EOS
        #{caveats}\
          mkdir -p ~LibraryJavaExtensions
          ln -s "#{opt_libexec}lib_jcsound6.jnilib" ~LibraryJavaExtensions
      EOS
    end

    on_linux do
      caveats = <<~EOS
        srconv is not installed because it conflicts with binutils. To run srconv:
          csound --utility=srconv

        #{caveats}\
          sudo mkdir -p usrjavapackageslib
          sudo ln -s "#{opt_libexec}lib_jcsound6.jnilib" usrjavapackageslib
      EOS
    end

    caveats
  end

  test do
    (testpath"test.orc").write <<~EOS
      0dbfs = 1
      gi_peer link_create
      gi_programHandle faustcompile "process = _;", "--vectorize --loop-variant 1"
      FLrun
      gi_fluidEngineNumber fluidEngine
      gi_realVector la_i_vr_create 1
      pyinit
      instr 1
          a_, a_, a_ chuap 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          a_signal STKPlucked 440, 1
          a_, a_ hrtfstat a_signal, 0, 0, sprintf("hrtf-%d-left.dat", sr), sprintf("hrtf-%d-right.dat", sr), 9, sr
          hdf5write "test.h5", a_signal
          mp3out a_signal, a_signal, "test.mp3"
          out a_signal
      endin
    EOS

    (testpath"test.sco").write <<~EOS
      i 1 0 1
      e
    EOS

    if OS.mac?
      ENV["OPCODE6DIR64"] = frameworks"CsoundLib64.frameworkResourcesOpcodes64"
      ENV["SADIR"] = frameworks"CsoundLib64.frameworkVersionsCurrentsamples"
    else
      ENV["OPCODE6DIR64"] = lib"csoundplugins64-6.0"
      ENV["SADIR"] = share"samples"
    end
    ENV["RAWWAVE_PATH"] = Formula["stk"].pkgshare"rawwaves"

    system bin"csound", "test.orc", "test.sco"

    assert_predicate testpath"test.#{OS.mac? ? "aif" : "wav"}", :exist?
    assert_predicate testpath"test.h5", :exist?
    assert_predicate testpath"test.mp3", :exist?

    (testpath"opcode-existence.orc").write <<~EOS
      JackoInfo
      instr 1
          i_ websocket 8888, 0
      endin
    EOS
    system bin"csound", "--orc", "--syntax-check-only", "opcode-existence.orc"

    if OS.mac?
      (testpath"mac-opcode-existence.orc").write <<~EOS
        instr 1
            p5gconnect
            i_ wiiconnect 1, 1
        endin
      EOS
      system bin"csound", "--orc", "--syntax-check-only", "mac-opcode-existence.orc"
    end

    system python3, "-c", "import ctcsound"

    (testpath"test.java").write <<~EOS
      import csnd6.*;
      public class test {
          public static void main(String args[]) {
              csnd6.csoundInitialize(csnd6.CSOUNDINIT_NO_ATEXIT | csnd6.CSOUNDINIT_NO_SIGNAL_HANDLER);
          }
      }
    EOS
    system Formula["openjdk"].bin"javac", "-classpath", "#{libexec}csnd6.jar", "test.java"
    system Formula["openjdk"].bin"java", "-classpath", "#{libexec}csnd6.jar:.",
                                          "-Djava.library.path=#{libexec}", "test"
  end
end