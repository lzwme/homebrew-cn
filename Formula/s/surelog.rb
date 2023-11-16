class Surelog < Formula
  include Language::Python::Virtualenv

  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://ghproxy.com/https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.80.tar.gz"
  sha256 "40e564bbacccce25ebcb00aca7a9a1abac711574674f71b056eb2b8015b89021"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "de7017b6cce054179b06481cbb70fcaecfc89493a6ddf10db9982fff64ccf7ac"
    sha256 cellar: :any,                 arm64_ventura:  "89ff8447929c212cdfec7562d943ce69bc3c1189b913d34307d111ff7f78fb36"
    sha256 cellar: :any,                 arm64_monterey: "d186c70bff7e78952f49a2ae6aef8fb9cd219e6bb8f261fa0a84e6b1dfcd5a15"
    sha256 cellar: :any,                 sonoma:         "2c3bb3de0c9349240a13fa0120f47570b001196ab0e66da8a14686b63691bf9b"
    sha256 cellar: :any,                 ventura:        "d6f639695906ad93e5d7154376eff9e66ef33a724f51e980b5791b2f88879bd1"
    sha256 cellar: :any,                 monterey:       "beb19bb4eca5e6a4e0fa51b1a2f9fa4087a3674612dee4a0fa4952c149c667f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78a0b0b950e804bb9eaa1f3d3a217cef63fc468af93f7b05e713ccecab9565c"
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