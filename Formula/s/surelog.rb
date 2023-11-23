class Surelog < Formula
  include Language::Python::Virtualenv

  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://ghproxy.com/https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.80.tar.gz"
  sha256 "40e564bbacccce25ebcb00aca7a9a1abac711574674f71b056eb2b8015b89021"
  license "Apache-2.0"
  revision 1
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36eb6a7687afd47c9768c43dada6061d04d61ad062ad597473afc849cf50e112"
    sha256 cellar: :any,                 arm64_ventura:  "aaf0f590745c4774d2c6a49ccb2259e802f1fbce3566fcd14f2f6d84303bc478"
    sha256 cellar: :any,                 arm64_monterey: "df75f6d22ca38c1f5f28e2a95bf626d36b3bd71b92fb415f9af6cf8dad752180"
    sha256 cellar: :any,                 sonoma:         "8e45345d2c2d01c769ae7f822f0db835b66072b5983ff8cea29e3fe1d493d63a"
    sha256 cellar: :any,                 ventura:        "2dcb9e4f097a56fceab955ada15046f8c9c779929dc3e76b6b0c2326d3c04033"
    sha256 cellar: :any,                 monterey:       "7400911040346fa39b6c102868b2411732cf0e3d04e1d7690a6b7a845ea98338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "729b38677a0d2cf9ea3eb715e3eafde1397a35e7eeee397e34f6c27f31a83c0a"
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
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  def python3
    which("python3.12")
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
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
      "-DANTLR_JAR_LOCATION=#{Formula["antlr"].opt_prefix}/antlr-#{Formula["antlr"].version}-complete.jar",
      "-DSURELOG_WITH_ZLIB=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DPython3_EXECUTABLE=#{buildpath}/venv/bin/python", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    # ensure linking is ok
    system bin/"surelog", "--version"

    # ensure library is ok
    (testpath/"test.cpp").write <<~EOS
      #include <Surelog/API/Surelog.h>
      #include <Surelog/CommandLine/CommandLineParser.h>
      #include <Surelog/Common/FileSystem.h>
      #include <Surelog/Design/Design.h>
      #include <Surelog/Design/ModuleInstance.h>
      #include <Surelog/ErrorReporting/ErrorContainer.h>
      #include <Surelog/SourceCompile/SymbolTable.h>
      #include <functional>
      #include <iostream>
      #include <uhdm/uhdm.h>
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
    system ENV.cxx, testpath/"test.cpp", "-o", "test",
      "-L#{Formula["antlr4-cpp-runtime"].opt_prefix}/lib",
      "-fPIC", "-std=c++17", *flags
    system testpath/"test"
  end
end