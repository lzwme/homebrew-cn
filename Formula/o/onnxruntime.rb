class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https:github.commicrosoftonnxruntime"
  url "https:github.commicrosoftonnxruntime.git",
      tag:      "v1.20.0",
      revision: "c4fb724e810bb496165b9015c77f402727392933"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "aa0d5c5c4a98f99e2cf5ccf870312e55265a61454ed73261d8967c05b8c16d45"
    sha256 cellar: :any,                 arm64_sonoma:  "43f68f494e03940b19596a26be44cfe3bdbe2a000712e5195b971c9ec37dc38e"
    sha256 cellar: :any,                 arm64_ventura: "e216b03eeeb9e0381c24097961e89a71e8f7e3ec97904f98298b1f384f1f7418"
    sha256 cellar: :any,                 sonoma:        "4a8b0a1c2be57bc688676f4c34e907b83cea90add8187f20963657823cf523da"
    sha256 cellar: :any,                 ventura:       "100dcfee870b334a5baa839ff5f2506e1845e37700aeed7740c3811b1b83e0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ab406b4452d337635cb4b4b5db33a3461d110baec4ce920d830af0cc249506"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "flatbuffers" => :build # NOTE: links to static library
  depends_on "howard-hinnant-date" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python@3.13" => :build
  depends_on "safeint" => :build
  depends_on "abseil"
  depends_on "nsync"
  depends_on "onnx"
  depends_on "protobuf@21" # https:github.commicrosoftonnxruntimeissues21308
  depends_on "re2"

  # Need newer than stable `eigen` after https:github.commicrosoftonnxruntimepull21492
  # element_wise_ops.cc:708:32: error: no matching member function for call to 'min'
  #
  # https:github.commicrosoftonnxruntimeblobv#{version}cmakedeps.txt#L25
  resource "eigen" do
    url "https:gitlab.comlibeigeneigen-archivee7248b26a1ed53fa030c5c459f7ea095dfd276aceigen-e7248b26a1ed53fa030c5c459f7ea095dfd276ac.tar.bz2"
    sha256 "a3f1724de1dc7e7f74fbcc206ffcaeba27fd89b37dc71f9c31e505634d0c1634"
  end

  # https:github.commicrosoftonnxruntimeblobv#{version}cmakedeps.txt#L52
  resource "pytorch_cpuinfo" do
    url "https:github.compytorchcpuinfoarchiveca678952a9a8eaa6de112d154e8e104b22f9ab3f.tar.gz"
    sha256 "c8f43b307fa7d911d88fec05448161eb1949c3fc0cb62f3a7a2c61928cdf2e9b"
  end

  # Backport fix for build on Linux
  patch do
    url "https:github.commicrosoftonnxruntimecommit4d614e15bd9e6949bc3066754791da403e00d66c.patch?full_index=1"
    sha256 "76f9920e591bc52ea80f661fa0b5b15479960004f1be103467b219e55c73a8cc"
  end

  def install
    python3 = which("python3.13")

    # Workaround to use brew `nsync`. Remove in future release with
    # https:github.commicrosoftonnxruntimecommit88676e62b966add2cc144a4e7d8ae1dbda1148e8
    inreplace "cmakeexternalonnxruntime_external_deps.cmake" do |s|
      s.gsub!( NAMES nsync unofficial-nsync$, " NAMES nsync_cpp")
      s.gsub!(\bunofficial::nsync::nsync_cpp\b, "nsync_cpp")
    end

    resources.each do |r|
      (buildpath"build_deps#{r.name}-src").install r
    end

    args = %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_SOURCE_DIR_PYTORCH_CLOG=#{buildpath}build_depspytorch_cpuinfo-src
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DPYTHON_EXECUTABLE=#{python3}
      -DONNX_CUSTOM_PROTOC_EXECUTABLE=#{Formula["protobuf@21"].opt_bin}protoc
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_USE_FULL_PROTOBUF=ON
    ]

    # Regenerate C++ bindings to use newer `flatbuffers`
    flatc = Formula["flatbuffers"].opt_bin"flatc"
    system python3, "onnxruntimecoreflatbuffersschemacompile_schema.py", "--flatc", flatc
    system python3, "onnxruntimeloraadapter_formatcompile_schema.py", "--flatc", flatc

    system "cmake", "-S", "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <onnxruntimeonnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lonnxruntime", "-o", "test"
    assert_equal version, shell_output(".test").strip
  end
end