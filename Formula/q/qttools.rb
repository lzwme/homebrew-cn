class Qttools < Formula
  desc "Facilitate the design, development, testing and deployment of applications"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qttools-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qttools-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qttools-everywhere-src-6.11.2.tar.xz"
  sha256 "9ea75af35c512f7e09e61c8c3af3997f13b4d43bb099cf43fcec470126b4041e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "BSD-3-Clause", # *.cmake
    "BSL-1.0", # bundled catch2
  ]
  head "https://code.qt.io/qt/qttools.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "66c37228f5f5ba71e26506035333923f608584b87c4cfcf691f5b552d8de32c3"
    sha256 cellar: :any, arm64_sequoia: "78b0f29ca849e22ff8dd14e28ac978e1cc9beb4824051497e408d66bc4a83c74"
    sha256 cellar: :any, arm64_sonoma:  "16d7aab73a91061c0e4429110992cb0ebd3b10caefa524311f966f4305e789bb"
    sha256 cellar: :any, arm64_linux:   "823d09fdb9907482ced3af13d2c978cdfdb67d6ca9ba4b0e9166ae99f754f05c"
    sha256 cellar: :any, x86_64_linux:  "86085d619081adc79b7b2f91e8ca2d1ef4a018cc041411f34884253aaa8609eb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "vulkan-headers" => :build

  depends_on "litehtml"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "zstd"

  on_macos do
    depends_on "gumbo-parser"
  end

  conflicts_with "qt@5", because: "both link conflicting binaries"

  # Backport qlitehtml's litehtml 0.10 support, which qttools has not pulled into its submodule yet.
  patch do
    file "Patches/qttools/litehtml-0.10.patch"
    type :backport
    resolves "https://code.qt.io/cgit/playground/qlitehtml.git/commit/?id=1f56cfe0a8e9a8a99072e0d325632bd8dc0e20d3"
  end

  def install
    rm_r("src/assistant/qlitehtml/src/3rdparty/litehtml")

    # Modify Assistant path as we manually move `*.app` bundles from `bin` to `prefix`.
    # This fixes invocation of Assistant via the Help menu of apps like Designer and
    # Linguist as they originally relied on Assistant.app being in `bin`.
    inreplace "src/shared/helpclient/assistantclient.cpp", '"Assistant.app/Contents/MacOS/Assistant"', '"Assistant"'

    # We disable clang feature to avoid linkage to `llvm`. This is how we have always
    # built on macOS and it prevents complicating `llvm` version bumps on Linux.
    args = %W[
      -DFEATURE_clang=OFF
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DQLITEHTML_USE_SYSTEM_LITEHTML=ON
    ]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework")

    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end
  end

  test do
    # Based on https://doc.qt.io/qt-6/qtlinguist-hellotr-example.html
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(hellotr LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS Core LinguistTools)
      qt_standard_project_setup(I18N_TRANSLATED_LANGUAGES la)
      qt_add_executable(hellotr main.cpp)
      qt6_add_translations(hellotr QM_FILES_OUTPUT_VARIABLE qm_files)
      target_link_libraries(hellotr PUBLIC Qt::Core)
    CMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <iostream>
      #include <QTranslator>

      int main(void) {
        QTranslator translator;
        Q_UNUSED(translator.load("hellotr_la"));
        std::cout << translator.translate("main", "Hello world!").toStdString();
        return 0;
      }
    CPP

    (testpath/"hellotr_la.ts").write <<~XML
      <?xml version="1.0" encoding="utf-8"?>
      <!DOCTYPE TS>
      <TS/>
    XML

    ENV["LC_ALL"] = "en_US.UTF-8"
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build", "--target", "update_translations"
    inreplace "hellotr_la.ts", '<translation type="unfinished"></translation>',
                               "<translation>Orbis, te saluto!</translation>"
    system "cmake", "--build", "build"
    # `QTranslator` resolves the relative catalog name against the working directory
    cd "build" do
      assert_equal "Orbis, te saluto!", shell_output("./hellotr")
    end
  end
end