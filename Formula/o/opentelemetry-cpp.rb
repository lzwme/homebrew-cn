class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://ghfast.top/https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "85aae7a42d7b71d17e510ddebc85db622d9078cc6d29cf9fb7373014b063859f"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3cc8f2c439b704bd24b4006478716caed959836744f03a05dceb6b39f7e7a88a"
    sha256 cellar: :any, arm64_tahoe:       "c309c0120c3fe3262d2546b4b281f384ac24da32493ce43cdba4db7417c54d29"
    sha256 cellar: :any, arm64_sequoia:     "0146d68692d2cfb135baf1daea623d7b6da463a5e02fec3920358310e098e8ed"
    sha256               arm64_linux:       "d56d7bfeee7fb428d52cd82cecfea8a8eed24a27947a10bb37ee38edf2548d37"
    sha256               x86_64_linux:      "b90bbfc97dae396db4e39ee471420fab6b77af6be818208bb6caeaddc7893a33"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "prometheus-cpp"
  depends_on "protobuf"

  uses_from_macos "curl"

  fails_with :gcc do
    version "12"
    cause "fails handling PROTOBUF_FUTURE_ADD_EARLY_WARN_UNUSED"
  end

  resource "opentelemetry-proto" do
    url "https://ghfast.top/https://github.com/open-telemetry/opentelemetry-proto/archive/refs/tags/v1.11.1.tar.gz"
    sha256 "c0bdd2ff083665e0504a6574923ebe53c60c086ea11836c5aa543683f55a6c32"
  end

  def install
    (buildpath/"opentelemetry-proto").install resource("opentelemetry-proto")

    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DCMAKE_CXX_STANDARD=17", # Keep in sync with C++ standard in abseil.rb
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
      "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
      "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS",
      "-DOTELCPP_PROTO_PATH=#{buildpath}/opentelemetry-proto",
      "-DWITH_BENCHMARK=OFF",
      "-DWITH_ELASTICSEARCH=ON",
      "-DWITH_EXAMPLES=OFF",
      "-DWITH_OTLP_GRPC=ON",
      "-DWITH_OTLP_HTTP=ON",
      "-DWITH_PROMETHEUS=ON",
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP
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