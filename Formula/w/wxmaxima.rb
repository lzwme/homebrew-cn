class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https:wxmaxima-developers.github.iowxmaxima"
  url "https:github.comwxMaxima-developerswxmaximaarchiverefstagsVersion-23.11.0.tar.gz"
  sha256 "f2fdd6386d89d461c29b9cff054e7118e98714123dbaf084a2e954c2a450cc4d"
  license "GPL-2.0-or-later"
  head "https:github.comwxMaxima-developerswxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(^Version[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "679bde347bc35155c1479d3814d237215555c62d043d40a9ac0e9ff82f2e1dbe"
    sha256 arm64_ventura:  "2f5cb889b07262e57afb26799d6f8e578063b61c252c841f2fb132bba0bf86ad"
    sha256 arm64_monterey: "0b90d38d64e95a99e8c4424e92ac25455dcb5e54a149dbd961eb1e62b9119759"
    sha256 sonoma:         "2f93a361f57848e3037477a5e48f18a8b528e316068bac6d26a4dbe473e3318e"
    sha256 ventura:        "4d4ea8cc332868aa7f648266c06fc90145095c13511d2ea0df1c1451a9f15a4b"
    sha256 monterey:       "c16f02666e7df28c8604a28d3a39903b2fd51818c3963dc825cf433ffb6ab7c2"
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

    system "cmake", "-S", ".", "-B", "build-wxm", "-G", "Ninja", *std_cmake_args
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

    assert_match "algebra", shell_output("#{bin}wxmaxima --help 2>&1")
  end
end