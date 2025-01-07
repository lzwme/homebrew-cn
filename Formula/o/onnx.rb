class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https:onnx.ai"
  url "https:github.comonnxonnxarchiverefstagsv1.17.0.tar.gz"
  sha256 "8d5e983c36037003615e5a02d36b18fc286541bf52de1a78f6cf9f32005a820e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0fe872816c9c83d21d581d36b2cae018c38b5006916ef20130ced9347b70c7a4"
    sha256 cellar: :any,                 arm64_sonoma:  "ef61f1b356976ba84e28ead5dde241e2695605756690abbc9c750c79dd51e269"
    sha256 cellar: :any,                 arm64_ventura: "d23869ed31b6263ed7af1184a445fafb28d2f906e49fbc967011de28764eced8"
    sha256 cellar: :any,                 sonoma:        "0e391f7435c1562de1482c6f620400f47b08946b974c1a079371d98f6dac9edb"
    sha256 cellar: :any,                 ventura:       "bb93c2d9ed8864e30705560ae553c8c4728677dac7ab019a6f57e7e5d3fd6a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb6b43d48d9afaeb14483b9825dc92b5cb2b9cbd53fcfa75d9512f7d77e7d194"
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
    # https:github.comonnxonnxblobmainonnxtestcppir_test.cc
    (testpath"test.cpp").write <<~CPP
      #include <cassert>
      #include <cctype>
      #include <memory>
      #include <string>
      #include <onnxcommonir.h>
      #include <onnxcommonir_pb_converter.h>
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

    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test LANGUAGES CXX)
      find_package(ONNX CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test ONNX::onnx)
    CMAKE

    ENV.delete "CPATH"
    args = ["-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"]
    args << "-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}lib" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system ".buildtest"
  end
end