class Onnx < Formula
  desc "Open standard for machine learning interoperability"
  homepage "https://onnx.ai/"
  url "https://ghfast.top/https://github.com/onnx/onnx/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "9bcd6473c689b1ac3aeba8df572891756e01c1a151ae788df5cbc7a4499e5db5"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6eab6ffeb8935d337316e8909fc8f219279b442347f9ac62f06edb3c336e3540"
    sha256 cellar: :any,                 arm64_sequoia: "e4f675af3727ba528d2cb101a45d3a56ed3094482c31635d7be1baf66b5c0f5f"
    sha256 cellar: :any,                 arm64_sonoma:  "2602812ff2f0e0671422e31298d49a59a57bb274ae157581f9743a1eb1f9d84a"
    sha256 cellar: :any,                 sonoma:        "035cc8831e70357e30d7f6b05f2e1162911361e8c35d628cb083287756eaa09b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e426f4564a0027407e1829814de7bd6fa78f029818155c914c260b22c5f5b952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d2c9fa7b22f0ba7186ac95694f4b14258fdfa755d1f8f938a3fd789848caeeb"
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
  end

  def install
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