class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://ghproxy.com/https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-23.11.0.tar.gz"
  sha256 "f2fdd6386d89d461c29b9cff054e7118e98714123dbaf084a2e954c2a450cc4d"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1928ded22b27a7947f666bdc117c3f08451f446686dff6998bd82355bdce5c75"
    sha256 arm64_ventura:  "acbac767d5e4c4e3a9f45105c2ca066577c533f3275aada35ca7660e3ebfd15a"
    sha256 arm64_monterey: "1c3d23fdd30b3efdfd733d6638f22ae214317c007ca8f0c6c4d4f17e3d21b0fd"
    sha256 sonoma:         "bec378e3765f6af196754b4354ed6bfe1135a3293fcbf77747716f4edcdcc1a9"
    sha256 ventura:        "b57cde6ec9c481277bf6d4f69f7a01742166152bf3a9b41d06f926d8e147e54b"
    sha256 monterey:       "620b4b0ad780363754a67b5e26ae74d481cf515ddfde6fdc800a2082846d6564"
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