class Surelog < Formula
  include Language::Python::Virtualenv

  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https:github.comchipsallianceSurelog"
  url "https:github.comchipsallianceSurelogarchiverefstagsv1.81.tar.gz"
  sha256 "5b7a01496f89638576d890b892600b14115f8639ea08b2b4b1b1a7cdde820bf0"
  license "Apache-2.0"
  head "https:github.comchipsallianceSurelog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fca25d77f5721defe7c7944205567b02798b9bfb011a785f765126ec18457c21"
    sha256 cellar: :any,                 arm64_ventura:  "200701a84d809161b3ab9e27c6b0f7bb6dbbef8a3c85a08d9e4b73e6218b8a79"
    sha256 cellar: :any,                 arm64_monterey: "013d746d45b65419409ce991ab6586415266025d364a57bb991f3a6cb1c47de6"
    sha256 cellar: :any,                 sonoma:         "84120eb1f1a16a9b228b70254217d53f98550b903d08e7e845230edda8e02183"
    sha256 cellar: :any,                 ventura:        "910da05ec679a4bd49a064f2f35cb530480886382922dac8bd5ee583f29d4df9"
    sha256 cellar: :any,                 monterey:       "61342b8ee7dfeeff2c4c19822231b3c44b7eca73c7bccf482ff73a6584bd708c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86e1b44d3d9e421ed23a726ec7964f16f59268351473fe5c5d341f6a05dac0b9"
  end

  depends_on "antlr" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openjdk" => :build
  depends_on "python@3.12" => :build
  depends_on "six" => :build
  depends_on "googletest" => :test
  depends_on "pkg-config" => :test
  depends_on "antlr4-cpp-runtime"
  depends_on "capnp"
  depends_on "uhdm"

  resource "orderedmultidict" do
    url "https:files.pythonhosted.orgpackages534e3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789forderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  def python3
    which("python3.12")
  end

  def install
    venv = virtualenv_create(buildpath"venv", python3)
    resources.each do |r|
      venv.pip_install r
    end

    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
      "-DBUILD_SHARED_LIBS=ON",
      "-DSURELOG_BUILD_TESTS=OFF",
      "-DSURELOG_USE_HOST_GTEST=ON",
      "-DSURELOG_USE_HOST_ANTLR=ON",
      "-DSURELOG_USE_HOST_CAPNP=ON",
      "-DSURELOG_USE_HOST_JSON=ON",
      "-DSURELOG_USE_HOST_UHDM=ON",
      "-DGTEST_LIBRARY=unused",
      "-DGTEST_INCLUDE_DIR=unused",
      "-DGTEST_MAIN_LIBRARY=unused",
      "-DANTLR_JAR_LOCATION=#{Formula["antlr"].opt_prefix}antlr-#{Formula["antlr"].version}-complete.jar",
      "-DSURELOG_WITH_ZLIB=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DPython3_EXECUTABLE=#{buildpath}venvbinpython", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    # ensure linking is ok
    system bin"surelog", "--version"

    # ensure library is ok
    (testpath"test.cpp").write <<~EOS
      #include <SurelogAPISurelog.h>
      #include <SurelogCommandLineCommandLineParser.h>
      #include <SurelogCommonFileSystem.h>
      #include <SurelogDesignDesign.h>
      #include <SurelogDesignModuleInstance.h>
      #include <SurelogErrorReportingErrorContainer.h>
      #include <SurelogSourceCompileSymbolTable.h>
      #include <functional>
      #include <iostream>
      #include <uhdmuhdm.h>
      int main(int argc, const char** argv) {
        uint32_t code = 0;
        SURELOG::SymbolTable* symbolTable = new SURELOG::SymbolTable();
        SURELOG::ErrorContainer* errors = new SURELOG::ErrorContainer(symbolTable);
        SURELOG::CommandLineParser* clp =
            new SURELOG::CommandLineParser(errors, symbolTable, false, false);
        clp->noPython();
        bool success = clp->parseCommandLine(argc, argv);
        errors->printMessages(clp->muteStdout());
        SURELOG::Design* the_design = nullptr;
        SURELOG::scompiler* compiler = nullptr;
        if (success && (!clp->help())) {
          compiler = SURELOG::start_compiler(clp);
          the_design = SURELOG::get_design(compiler);
          auto stats = errors->getErrorStats();
          code = (!success) | stats.nbFatal | stats.nbSyntax | stats.nbError;
        }
        if (the_design) {
          for (auto& top : the_design->getTopLevelModuleInstances()) {
            std::function<void(SURELOG::ModuleInstance*)> inst_visit =
              [&inst_visit](SURELOG::ModuleInstance* inst) {
                SURELOG::FileSystem* const fileSystem =
                  SURELOG::FileSystem::getInstance();
                  std::cout << "Inst: " << inst->getFullPathName() << std::endl;
                  std::cout << "File: " << fileSystem->toPath(inst->getFileId())
                    << std::endl;
              for (uint32_t i = 0; i < inst->getNbChildren(); i++) {
                inst_visit(inst->getChildren(i));
              }
            };
            inst_visit(top);
          }
        }
        if (success && (!clp->help())) {
          SURELOG::shutdown_compiler(compiler);
        }
        delete clp;
        delete symbolTable;
        delete errors;
        return code;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs Surelog").chomp.split
    system ENV.cxx, testpath"test.cpp", "-o", "test",
      "-L#{Formula["antlr4-cpp-runtime"].opt_prefix}lib",
      "-fPIC", "-std=c++17", *flags
    system testpath"test"
  end
end