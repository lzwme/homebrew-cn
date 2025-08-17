class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  url "https://ghfast.top/https://github.com/onnx/onnx/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "8d5e983c36037003615e5a02d36b18fc286541bf52de1a78f6cf9f32005a820e"
  license "Apache-2.0"
  revision 5

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "362c930e63c6bb6f812af7a93b198f80004d17123c2cf4e05a5fa7880209d957"
    sha256 cellar: :any, arm64_sonoma:  "489c11e3f257c27b5bdf965e8a61e73d07b24e7dd32dfcaf73f6b41210286a90"
    sha256 cellar: :any, arm64_ventura: "fc7f3bfbecf7f990c6271fbc4a790c318374f23e437e7e233be918e8b30a7003"
    sha256 cellar: :any, sonoma:        "6e2677f5ddb1d8410efc671fd17b5c72f409914369530340d2efc3eda09ad89f"
    sha256 cellar: :any, ventura:       "adf4d72283691535d05613410ac81df6195601d8f63cd57dd5dc3acec140d319"
    sha256               arm64_linux:   "130209171871c8d30a0262f212af8ab21069bf34b5e0e6856133692f4ab9762f"
    sha256               x86_64_linux:  "84660099b1e857649c87162f422c6902034f6ada912e6d37f3977d4d8faeb391"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DONNX_USE_PROTOBUF_SHARED_LIBS=ON
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # https://github.com/onnx/onnx/blob/main/onnx/test/cpp/ir_test.cc
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <cctype>
      #include <memory>
      #include <string>
      #include <onnx/common/ir.h>
      #include <onnx/common/ir_pb_converter.h>
      using namespace onnx;

      bool IsValidIdentifier(const std::string& name) {
        if (name.empty()) {
          return false;
        }
        if (!isalpha(name[0]) && name[0] != '_') {
          return false;
        }
        for (size_t i = 1; i < name.size(); ++i) {
          if (!isalnum(name[i]) && name[i] != '_') {
            return false;
          }
        }
        return true;
      }

      int main() {
        Graph* g = new Graph();
        g->setName("test");
        Value* x = g->addInput();
        x->setUniqueName("x");
        x->setElemType(TensorProto_DataType_FLOAT);
        x->setSizes({Dimension("M"), Dimension("N")});
        Node* node1 = g->create(kNeg, 1);
        node1->addInput(x);
        g->appendNode(node1);
        Value* temp1 = node1->outputs()[0];
        Node* node2 = g->create(kNeg, 1);
        node2->addInput(temp1);
        g->appendNode(node2);
        Value* y = node2->outputs()[0];
        g->registerOutput(y);

        ModelProto model;
        ExportModelProto(&model, std::shared_ptr<Graph>(g));

        for (auto& node : model.graph().node()) {
          for (auto& name : node.output()) {
            assert(IsValidIdentifier(name));
          }
        }
        return 0;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test LANGUAGES CXX)
      find_package(ONNX CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test ONNX::onnx)
    CMAKE

    ENV.delete "CPATH"
    args = ["-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"]
    args << "-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end