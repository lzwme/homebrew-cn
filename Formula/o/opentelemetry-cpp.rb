class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https://opentelemetry.io/"
  url "https://ghfast.top/https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "3428f433f4b435ed1fad64cbdbe75b7288c06f6297786a7036d65d5b9a1d215b"
  license "Apache-2.0"
  revision 4
  head "https://github.com/open-telemetry/opentelemetry-cpp.git", branch: "main"

  bottle do
    sha256               arm64_sequoia: "2a5db4987a8d12bf4efb1442f89bc66293ac8a3b1bf4620eaff2f334b3a2b116"
    sha256               arm64_sonoma:  "daf98ce670b8e08a5951ddcc01ba3fa7a7304c25c087c609f05719d8711c0a1b"
    sha256               arm64_ventura: "c95443f7841430d824f621db7e21694e96ca23f1791acce7c10a611a81fe4d4f"
    sha256 cellar: :any, sonoma:        "b9e8ff8973f8e426e08e0f5bdb4ebb043c303ef22db9db6251e4b1b6b9df4188"
    sha256 cellar: :any, ventura:       "75aea7be90f39506820e4a0d0e7037c571752f9cf6ac2f361b7059c14e299399"
    sha256               arm64_linux:   "978ab81e42eeff8a5ba66ea060bf679f0983a29b2a06bb82a0787ba094710bbe"
    sha256               x86_64_linux:  "4bc987ac3e32c13b4ed4aa4f9d47144531170fcb9a553ee1298c4bf5de0f4fa6"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
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

  resource "openetelemetry-proto" do
    url "https://ghfast.top/https://github.com/open-telemetry/opentelemetry-proto/archive/refs/tags/v1.7.0.tar.gz"
    sha256 "11330d850f5e24d34c4246bc8cb21fcd311e7565d219195713455a576bb11bed"
  end

  def install
    (buildpath/"opentelemetry-proto").install resource("openetelemetry-proto")

    ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup" if OS.mac?
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_CXX_STANDARD=17", # Keep in sync with C++ standard in abseil.rb
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
                    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
                    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS",
                    "-DOTELCPP_PROTO_PATH=#{buildpath}/opentelemetry-proto",
                    "-DWITH_ELASTICSEARCH=ON",
                    "-DWITH_EXAMPLES=OFF",
                    "-DWITH_OTLP_GRPC=ON",
                    "-DWITH_OTLP_HTTP=ON",
                    "-DWITH_ABSEIL=ON",
                    "-DWITH_PROMETHEUS=ON",
                    *std_cmake_args
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