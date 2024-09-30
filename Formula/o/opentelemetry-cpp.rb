class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https:opentelemetry.io"
  url "https:github.comopen-telemetryopentelemetry-cpparchiverefstagsv1.16.1.tar.gz"
  sha256 "b8a78bb2a3a78133dbb08bcd04342f4b1e03cb4a19079b8416d408d905fffc37"
  license "Apache-2.0"
  revision 6
  head "https:github.comopen-telemetryopentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c5bdc4512e77b1b8870b3fc48399f13b088abf27e369bebd14d3c56ade17539"
    sha256 cellar: :any,                 arm64_sonoma:  "72f8bd59002e47babeeb47123794d4bf83784a2c218c563667387b064dd62677"
    sha256 cellar: :any,                 arm64_ventura: "243e9c4f1ba5abe3fcc2d5d2bf88f1354a18449df45a51fc2a46f53f2129d0d0"
    sha256 cellar: :any,                 sonoma:        "efa1495775b734730b64dda4b10b02d3f49d17185cef9551c4b7cc4cb2aca2b0"
    sha256 cellar: :any,                 ventura:       "160b7d91ee7713256ee6e4536405157528811b9074192e6da966613048c40b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc57ff00fa94eaeb0805523017bb3c9baaa3c7b5626e24e1500e804541163a7"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "prometheus-cpp"
  depends_on "protobuf"

  uses_from_macos "curl"

  on_macos do
    depends_on "c-ares"
    depends_on "openssl@3"
    depends_on "re2"
  end

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