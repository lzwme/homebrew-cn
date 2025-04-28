class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https:wxmaxima-developers.github.iowxmaxima"
  url "https:github.comwxMaxima-developerswxmaximaarchiverefstagsVersion-25.04.0.tar.gz"
  sha256 "ec0b3005c3663f1bb86b0cc5028c2ba121e1563e3d5b671afcb9774895f4191b"
  license "GPL-2.0-or-later"
  head "https:github.comwxMaxima-developerswxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(^Version[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:  "651e94d18f6e8d0607f2a9c2704e27a5f8706154136b9e84291f4c56a38b5b4a"
    sha256 arm64_ventura: "2cb41dd7ab37788045aabd96c2bc7872c4e018d17d8ad7fffc8e1324948c3583"
    sha256 sonoma:        "f37079c11ec5d8e79ef364cb0938fe45f7ef0982e41edb30c60101c24f8a78e6"
    sha256 ventura:       "46fe42c449be5e2b2be2f4b8309ccff0eb60583e49078b46da4130ce70838f31"
    sha256 x86_64_linux:  "22bc6ecaa698b1408fa9f659d44b4d7eabe1ef9cd2da11c4c8621a132a8a95c0"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build

  depends_on "maxima"
  depends_on "wxwidgets"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  fails_with :clang do
    build 1300
    cause <<~EOS
      ...srcMathParser.cpp:1239:10: error: no viable conversion from returned value
      of type 'CellListBuilder<>' to function return type 'std::unique_ptr<Cell>'
        return tree;
               ^~~~
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1300)

    # Disable CMake fixup_bundle to prevent copying dylibs
    inreplace "srcCMakeLists.txt", "fixup_bundle(", "# \\0"

    # https:github.comwxMaxima-developerswxmaximablobmainCompiling.md#wxwidgets-isnt-found
    args = OS.mac? ? [] : ["-DWXM_DISABLE_WEBVIEW=ON"]

    system "cmake", "-S", ".", "-B", "build-wxm", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build-wxm"
    system "cmake", "--install", "build-wxm"
    bash_completion.install "datawxmaxima"

    return unless OS.mac?

    bin.write_exec_script prefix"wxmaxima.appContentsMacOSwxmaxima"
  end

  def caveats
    <<~EOS
      When you start wxMaxima the first time, set the path to Maxima
      (e.g. #{HOMEBREW_PREFIX}binmaxima) in the Preferences.

      Enable gnuplot functionality by setting the following variables
      in ~.maximamaxima-init.mac:
        gnuplot_command:"#{HOMEBREW_PREFIX}bingnuplot"$
        draw_command:"#{HOMEBREW_PREFIX}bingnuplot"$
    EOS
  end

  test do
    # Error: Unable to initialize GTK+, is DISPLAY set properly
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "wxMaxima #{version}", shell_output(bin"wxmaxima --version 2>&1").chomp
    assert_match "extra Maxima arguments", shell_output("#{bin}wxmaxima --help 2>&1", 1)
  end
end