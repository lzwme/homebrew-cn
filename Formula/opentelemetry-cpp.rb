class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  # TODO: Check if we can use unversioned `grpc` and `protobuf` at version bump.
  url "https://ghproxy.com/https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "668de24f81c8d36d75092ad9dcb02a97cd41473adbe72485ece05e336db48249"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c017afd677a9a7ffeaca95802501acca8e9bb2f39198f3eb8e50369cb37ff4e8"
    sha256 cellar: :any,                 arm64_monterey: "ff83b5b54d1c1d4426d178099fda960355002b58a1b2e9f4339a0298f34e8ae4"
    sha256 cellar: :any,                 arm64_big_sur:  "1019ce81ac7c511dd70628d23c5327ee48db252876086d32765dcf6c233ca5a1"
    sha256 cellar: :any,                 ventura:        "b6be466f4f4fde9e44d26ca7c4793046c905ed5eeea4f7f41c49d974989b8e87"
    sha256 cellar: :any,                 monterey:       "948cd713fa9367d563efb6bf29074fbc3a82d7a67eba219aedb858542df8fccf"
    sha256 cellar: :any,                 big_sur:        "2a23c4ea823a4bb909f7eaf3adfc946a60c57e69d3c44c3af465e30faf650a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d8d7433417685b7a23d0b89f874e59c3cb6f224b0f9f01f3b6a9c6f41be6e53"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "grpc@1.54"
  depends_on "nlohmann-json"
  depends_on "prometheus-cpp"
  depends_on "protobuf@21"
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
                    "-DWITH_LOGS_PREVIEW=ON",
                    "-DWITH_METRICS_PREVIEW=ON",
                    "-DWITH_OTLP=ON",
                    "-DWITH_OTLP_GRPC=ON",
                    "-DWITH_OTLP_HTTP=ON",
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

        auto tracer = provider->GetTracer("library", OPENTELEMETRY_SDK_VERSION);
        auto scoped_span = trace_api::Scope(tracer->StartSpan("test"));
      }
    EOS
    # Manual `protobuf` include can be removed when we depend on unversioned protobuf.
    system ENV.cxx, "test.cc", "-std=c++17",
                    "-I#{include}", "-L#{lib}",
                    "-I#{Formula["protobuf@21"].opt_include}",
                    "-lopentelemetry_resources",
                    "-lopentelemetry_exporter_ostream_span",
                    "-lopentelemetry_trace",
                    "-lopentelemetry_common",
                    "-pthread",
                    "-o", "simple-example"
    system "./simple-example"
  end
end