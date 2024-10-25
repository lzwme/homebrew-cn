class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https:opentelemetry.io"
  url "https:github.comopen-telemetryopentelemetry-cpparchiverefstagsv1.17.0.tar.gz"
  sha256 "13542725463f1ea106edaef078c2276065cf3da998cb1d3dcf92630daa3f64d4"
  license "Apache-2.0"
  revision 2
  head "https:github.comopen-telemetryopentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2e975a3b43569930f0933e40d551d2a155771bf63c7a8a2f2cecfe4f82671a5"
    sha256 cellar: :any,                 arm64_sonoma:  "ca85513cc422dbd210f7fbef9d43c5f5be4e774be62950174af726b751b3be49"
    sha256 cellar: :any,                 arm64_ventura: "33b00a64453791ac5353adab3ef0337224dade6c69e50d11a5410b817d6f88ca"
    sha256 cellar: :any,                 sonoma:        "891380880f943556524624c65caf806fc5f4e7bdbd5ad520e3f1555479d37c14"
    sha256 cellar: :any,                 ventura:       "a981557e3d60045eb7aa6392eb58c0ac12c97982e9803a751b2bca4fbd0e0211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e79bf2939f6977f3d66bfbe7c0508f64ae0353408fee3822c82bd3a2adfc458e"
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