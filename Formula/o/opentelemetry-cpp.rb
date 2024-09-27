class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https:opentelemetry.io"
  url "https:github.comopen-telemetryopentelemetry-cpparchiverefstagsv1.16.1.tar.gz"
  sha256 "b8a78bb2a3a78133dbb08bcd04342f4b1e03cb4a19079b8416d408d905fffc37"
  license "Apache-2.0"
  revision 5
  head "https:github.comopen-telemetryopentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da6657c9876e9fda7629aa2f5e3be42eae2e8fd7c82f1aa724c200b5a422cf4e"
    sha256 cellar: :any,                 arm64_sonoma:  "572fbe7a72c7278fef8905f719a2c24bb45986a8bf453dc48aa4647da78c3c7e"
    sha256 cellar: :any,                 arm64_ventura: "d0567368bf580a02ec0d11252faefc3eb4a738ee45bb15ce7cda42398dcf0e98"
    sha256 cellar: :any,                 sonoma:        "d2f91046fe9a99cc64c5228416c39782b0e855674c1ec999bd9a430cfbf39e6a"
    sha256 cellar: :any,                 ventura:       "4443afade54697172374b6e0378a59688164e41178907396163d88db71d09675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e06a3bd9b1f2758dcc442df0b743df16dfe3511c3c8bde6c4571293d73e37b2e"
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