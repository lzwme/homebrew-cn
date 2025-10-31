class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.38",
      revision: "f571f444ebf1d06521408b51f2c6ec2ca3c2f818"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da07f9033d3f4a8ca3d1921548a9ef08f1e0e9e46f4a1289e52f623cd0d5e42e"
    sha256 cellar: :any,                 arm64_sequoia: "c610ef4df5bf250acf48fbb4ba722017bdf74531efe531eb0c07abec25733e88"
    sha256 cellar: :any,                 arm64_sonoma:  "928dc19f5d5be568613a2846e6521ac802eff4ed05e763554a22defeb651d453"
    sha256 cellar: :any,                 sonoma:        "156e54ebc8d7b34147cc7bd63d16f341922425d8c9312082c9126885e3420f27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a87f15b62909b0d90e98ddd67056ba7edc6bddea910fb480ab98a89178ca4f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9941c4334ae8a592d231d446d8d7f21b1e15e59602f1f57212f217feb467eb47"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?

    args = %w[
      -DBUILD_TESTS=OFF
      -DWITH_WASI=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", *args, *std_cmake_args

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system bin/"wat2wasm", testpath/"sample.wast"
  end
end