class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  url "https://ghfast.top/https://github.com/onnx/onnx/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "c8732e2711faba94caf208b75d0c28c2ea473ab0bf57a01b1176e5f0d51a6c06"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e49c7e550e13766b71c6c1871145d02dd811072bd6479cb215de3f7cbf1ec6c0"
    sha256 cellar: :any, arm64_tahoe:       "9f025e004999c4b778833b12a9aec17dcfa9f44342d38299201f3a246c7eebac"
    sha256 cellar: :any, arm64_sequoia:     "372e29e26007da321f6c7dbbc100245680057edb73fb992a6a13ab9d7b5bb0d6"
    sha256 cellar: :any, arm64_linux:       "e1d1edc149d8bf7ffb95b56adfa5ddf0bb813cd6ca96c6798d37fd731eb2292b"
    sha256 cellar: :any, x86_64_linux:      "62c515f5f2e210d582d31c3b50ff5669e4ffe456e4e8e52d5f451d596aa52bb5"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "python" => :build

  # Apply Fedora's workaround to allow `onnxruntime` to use `onnx` built without
  # ONNX_DISABLE_STATIC_REGISTRATION[^1]. We can't use this option as it will
  # break functionality for any dependents/users expecting the default behavior.
  #
  # [^1]: https://github.com/microsoft/onnxruntime/issues/8556#issuecomment-1006091632
  patch do
    url "https://src.fedoraproject.org/rpms/onnx/raw/4de8a450afd87b1ba1931f50d841e9c50b63d8a0/f/0004-Add-fixes-for-use-with-onnxruntime.patch"
    sha256 "d9ddb735c065fd5dae11ab79371e62bdcca157a6d2a7705cc83ee612abeaaa98"
    type :unofficial
    resolves "https://github.com/microsoft/onnxruntime/issues/8556"
  end

  def install
    # FIXME: From v1.22+, onnx internals are hidden by default, which breaks
    # onnxruntime's usage of onnx as a dependency. We need to make them visible again.
    inreplace "CMakeLists.txt", "CXX_VISIBILITY_PRESET hidden", "CXX_VISIBILITY_PRESET default"

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DONNX_USE_LITE_PROTO=ON
      -DONNX_USE_PROTOBUF_SHARED_LIBS=ON
      -DPython3_EXECUTABLE=#{which("python3")}
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
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      find_package(Protobuf CONFIG REQUIRED)
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