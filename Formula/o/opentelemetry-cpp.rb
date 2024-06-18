class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https:opentelemetry.io"
  url "https:github.comopen-telemetryopentelemetry-cpparchiverefstagsv1.14.2.tar.gz"
  sha256 "c7e7801c9f6228751cdb9dd4724d0f04777ed53f524c8828e73bf4c9f894e0bd"
  license "Apache-2.0"
  revision 4
  head "https:github.comopen-telemetryopentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7bfcfe5f237e89d0a8cb31a82172030062849ba5608a6d0ba5ad631b59e06edc"
    sha256 cellar: :any,                 arm64_ventura:  "c3276662f2f327be8d3aa5947490a421967e4eb06fd8830bd72a4d888e0866e3"
    sha256 cellar: :any,                 arm64_monterey: "fa6bb6774033aee16bfa5efb3ee772d7a203463da5db3068ee5ce00e5b22cb37"
    sha256 cellar: :any,                 sonoma:         "e483232dac303523834b651b46c689e799b73d29994006226ff00baf1945c042"
    sha256 cellar: :any,                 ventura:        "08e3d0af90079eac4ac7036da30c7bceb3614f8e5b47d2ec57d79977abb92cfe"
    sha256 cellar: :any,                 monterey:       "98ed613a06f7f83c3c9614a20366a7e529db431148b7bb92030c6e0645dfd27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "769c0f9357e956ae737a5af8daae248c40d515796351a4b824d5895c8145eaa7"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "prometheus-cpp"
  depends_on "protobuf"
  uses_from_macos "curl"

  def install
    ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup" if OS.mac?
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # Keep in sync with C++ standard in abseil.rb
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_TESTING=OFF",
                    "-DWITH_ELASTICSEARCH=ON",
                    "-DWITH_EXAMPLES=OFF",
                    "-DWITH_JAEGER=OFF", # deprecated, needs older `thrift`
                    "-DWITH_METRICS_PREVIEW=ON",
                    "-DWITH_OTLP_GRPC=ON",
                    "-DWITH_OTLP_HTTP=ON",
                    "-DWITH_ABSEIL=ON",
                    "-DWITH_PROMETHEUS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cc").write <<~EOS
      #include "opentelemetrysdktracesimple_processor.h"
      #include "opentelemetrysdktracetracer_provider.h"
      #include "opentelemetrytraceprovider.h"
      #include "opentelemetryexportersostreamspan_exporter.h"
      #include "opentelemetryexportersotlpotlp_recordable_utils.h"

      namespace trace_api = opentelemetry::trace;
      namespace trace_sdk = opentelemetry::sdk::trace;
      namespace nostd     = opentelemetry::nostd;

      int main()
      {
        auto exporter = std::unique_ptr<trace_sdk::SpanExporter>(
            new opentelemetry::exporter::trace::OStreamSpanExporter);
        auto processor = std::unique_ptr<trace_sdk::SpanProcessor>(
            new trace_sdk::SimpleSpanProcessor(std::move(exporter)));
        auto provider = nostd::shared_ptr<trace_api::TracerProvider>(
            new trace_sdk::TracerProvider(std::move(processor)));

         Set the global trace provider
        trace_api::Provider::SetTracerProvider(provider);

        auto tracer = provider->GetTracer("foo_library", "1.0.0");
        auto scoped_span = trace_api::Scope(tracer->StartSpan("test"));
      }
    EOS
    system ENV.cxx, "test.cc", "-std=c++17",
                    "-DHAVE_ABSEIL",
                    "-I#{include}", "-L#{lib}",
                    "-lopentelemetry_resources",
                    "-lopentelemetry_exporter_ostream_span",
                    "-lopentelemetry_trace",
                    "-lopentelemetry_common",
                    "-pthread",
                    "-o", "simple-example"
    system ".simple-example"
  end
end