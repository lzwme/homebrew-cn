class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://ghproxy.com/https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-23.08.0.tar.gz"
  sha256 "f45fc63aab68e39501500fe2f24021915cfdbc1d2650443d88e42a223c8df517"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "5aa0984656d62d72a79e205b577dacc995cb6f9e4f4cfcbb129dac93221b6316"
    sha256 arm64_monterey: "1f36bcd5d91d0b01739ff6d0c3c75ee92122a14da2886d0c04eca55b54f42025"
    sha256 arm64_big_sur:  "0d09ddf5ad1bcf9dabb051453a64434653d93ca286d18f6b67a2b3c60eb84ea5"
    sha256 ventura:        "9ec3cfb3798eb008e9df24173dfcd4ddbe8731be897512047e0d50734fdec88e"
    sha256 monterey:       "ff72155120c98985b3f4cfa1caa63e2788e1416b02ef1a6cad2f886d01a0df61"
    sha256 big_sur:        "a1db524bc151e79ca4730bd24b9e523ebdafb7a89cc3a949856b3a59bda70368"
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
      .../src/MathParser.cpp:1239:10: error: no viable conversion from returned value
      of type 'CellListBuilder<>' to function return type 'std::unique_ptr<Cell>'
        return tree;
               ^~~~
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1300)

    system "cmake", "-S", ".", "-B", "build-wxm", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build-wxm"
    system "cmake", "--install", "build-wxm"
    bash_completion.install "data/wxmaxima"

    return unless OS.mac?

    prefix.install "build-wxm/src/wxMaxima.app"
    bin.write_exec_script prefix/"wxMaxima.app/Contents/MacOS/wxmaxima"
  end

  def caveats
    <<~EOS
      When you start wxMaxima the first time, set the path to Maxima
      (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

      Enable gnuplot functionality by setting the following variables
      in ~/.maxima/maxima-init.mac:
        gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
        draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    # Error: Unable to initialize GTK+, is DISPLAY set properly
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end