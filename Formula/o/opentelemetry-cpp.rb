class OpentelemetryCpp < Formula
  desc "OpenTelemetry C++ Client"
  homepage "https:opentelemetry.io"
  url "https:github.comopen-telemetryopentelemetry-cpparchiverefstagsv1.16.1.tar.gz"
  sha256 "b8a78bb2a3a78133dbb08bcd04342f4b1e03cb4a19079b8416d408d905fffc37"
  license "Apache-2.0"
  revision 3
  head "https:github.comopen-telemetryopentelemetry-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47ff7f416a13cf8dcd4dd7fd2ba837e5748c24d0cf6bde75387da04f6b6a73e8"
    sha256 cellar: :any,                 arm64_ventura:  "796210f7bb0b42e726694163d6478f01d645282380503adbbf41ebcebb0b08ab"
    sha256 cellar: :any,                 arm64_monterey: "659b3536d7559df2ab7692676292dba2dad4b4b0cf9221239cb55d07d0df7163"
    sha256 cellar: :any,                 sonoma:         "fd7922879838f1105122962a2326105a114e252dfa1e7594938d43545fc5c1d7"
    sha256 cellar: :any,                 ventura:        "58c5be13de2f3367d46a46fb8e3eef75378f1a3b985707284de26d4b7918e6d7"
    sha256 cellar: :any,                 monterey:       "e92bbd7d2ff71e12e02d2d7d85497fc6de42788f7c34c2eebadde0e13a19a001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f6ee6c3e200f9d6beace2f54b741967846c3c7757513ca188081e69af520bfa"
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