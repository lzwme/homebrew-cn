class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://ghproxy.com/https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "09c208a21fb1159d114a3ea15dc1bcc5dee28eb39907ba72a6012d2c7b7564a0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a4824620a983eeeec90c204746312b149f0d968903282c8bbcb8e89f7c75c89"
    sha256 cellar: :any,                 arm64_ventura:  "2c75e6f3ecd84e88b7e7580509ce8786bd0c75a62bb308ecfd9c6f01ce1e668d"
    sha256 cellar: :any,                 arm64_monterey: "80c95f86ebf5ec0d2fa5cb7b671fb4407c4ac1def08cd0973ede81ac0e747463"
    sha256 cellar: :any,                 sonoma:         "6bd5da535856563d08ed79e32ffbc84a4234ce20420d592349b25ed2f6e4ab0f"
    sha256 cellar: :any,                 ventura:        "cc4b5d7b511e7a14f2a0a47cd6c88aca76f906730e5f1a9548ff72c56321f813"
    sha256 cellar: :any,                 monterey:       "89628301de15c51d05787463e49a9953a28cd84fd15f68756cc6787e54a86302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea480b7229c5502e1b005300aabbbb6ee2ecbf5a2c7ed870cee03746e33ae8da"
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
    (testpath/"test.cc").write <<~EOS
      #include "opentelemetry/sdk/trace/simple_processor.h"
      #include "opentelemetry/sdk/trace/tracer_provider.h"
      #include "opentelemetry/trace/provider.h"
      #include "opentelemetry/exporters/ostream/span_exporter.h"
      #include "opentelemetry/exporters/otlp/otlp_recordable_utils.h"

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

        // Set the global trace provider
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
    system "./simple-example"
  end
end