class Qtscxml < Formula
  desc "Provides functionality to create state machines from SCXML files"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtscxml-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtscxml-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtscxml-everywhere-src-6.12.0.tar.xz"
  sha256 "adc04875b383256bcd5a412f6f249d363495ea037913ca8c96d723442be38383"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qscxmlc
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtscxml.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "baec4dc4ee72166852670c999761531ae872ed9f9b2d69f07018255679cd8efd"
    sha256 cellar: :any, arm64_tahoe:       "81e03ebeb293035b6cf2536cc373ea19e4afd9b7db56912d41ec5f4cac4a75ec"
    sha256 cellar: :any, arm64_sequoia:     "dab721dcc017ad7e1c4834e655458b8caa4bbd872e72c5ed3d031f037a112c8d"
    sha256 cellar: :any, arm64_linux:       "3dd0e8a462ab90f6a9161b7d8ec3a3d13b2da0bf486808fb020ad920765ab544"
    sha256 cellar: :any, x86_64_linux:      "3d39a325a1abec9349546fbe075af93b0ffda484b123b44011bb278392ac6c3b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"

  conflicts_with "qt@5", because: "both link conflicting binaries"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS Scxml)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Scxml)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += scxml
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"statemachine.scxml").write <<~XML
      <?xml version="1.0" ?>
      <scxml xmlns="http://www.w3.org/2005/07/scxml" version="1.0" initial="a">
        <state id="a"><transition event="step" target="b"/></state>
        <state id="b"><transition event="step" target="c"/></state>
        <final id="c"/>
      </scxml>
    XML

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QScopedPointer>
      #include <QScxmlStateMachine>
      #include <QString>

      int main(void) {
        QScopedPointer<QScxmlStateMachine> stateMachine(
          QScxmlStateMachine::fromFile(QString("#{testpath}/statemachine.scxml")));
        Q_ASSERT(!stateMachine.isNull());
        Q_ASSERT(stateMachine->parseErrors().isEmpty());
        auto states = stateMachine->stateNames();
        Q_ASSERT(states.size() == 3);
        Q_ASSERT(states.at(1) == QLatin1String("b"));
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system formula_opt_bin("qtbase")/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Scxml").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end