class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://ghfast.top/https://github.com/grpc/grpc-web/archive/refs/tags/1.5.0.tar.gz"
  sha256 "d3043633f1c284288e98e44c802860ca7203c7376b89572b5f5a9e376c2392d5"
  license "Apache-2.0"
  revision 12

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b87de0aa2eae8c10562fee463da895c56f3700660525a08d42eccee5f2cca0e5"
    sha256 cellar: :any,                 arm64_sonoma:  "a27c4ffe934eb8db7371ed4506287ae5a397c8d5efc1423bdb21e477b4449c7a"
    sha256 cellar: :any,                 arm64_ventura: "2eba49ffea8845913493b00a97754543cbf466bf5227253a98c96d8ecc735c35"
    sha256 cellar: :any,                 sonoma:        "703eeeaddffe653ff9f15477256155117a6be85d0d434a393ea3f5bb3f223eb6"
    sha256 cellar: :any,                 ventura:       "c1cb855cc87670760e71dbbc96ed36092dffb5e93c2354203e35dfe2a807cbe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55dcade960b581004d9a91dbc539d5f53ff7cfefaa9b0019b3dd8b20c788d53b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaeb60857291bff6bdd2c66812d37acc924ede863a635719cb1618bdf1522ff6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf@29"
  depends_on "protoc-gen-js"

  # Backport of https://github.com/grpc/grpc-web/commit/2c39859be8e5bcf55eef129e5a5330149ce460ab
  patch :DATA

  def install
    # Workarounds to build with latest `protobuf` which needs Abseil link flags and C++17
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp
    inreplace "javascript/net/grpc/web/generator/Makefile", "-std=c++11", "-std=c++17"

    args = ["PREFIX=#{prefix}", "STATIC=no"]
    args << "MIN_MACOS_VERSION=#{MacOS.version}" if OS.mac?

    system "make", "install-plugin", *args
  end

  test do
    # First use the plugin to generate the files.
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
      message TestResult {
        bool passed = 1;
      }
      service TestService {
        rpc RunTest(Test) returns (TestResult);
      }
    PROTO
    protoc = Formula["protobuf@29"].bin/"protoc"
    system protoc, "test.proto", "--plugin=#{bin}/protoc-gen-grpc-web",
                   "--js_out=import_style=commonjs:.",
                   "--grpc-web_out=import_style=typescript,mode=grpcwebtext:."

    # Now see if we can import them.
    (testpath/"test.ts").write <<~TYPESCRIPT
      import * as grpcWeb from 'grpc-web';
      import {TestServiceClient} from './TestServiceClientPb';
      import {Test, TestResult} from './test_pb';
    TYPESCRIPT
    system "npm", "install", *std_npm_args(prefix: false), "grpc-web", "@types/google-protobuf"
    # Specify including lib for `tsc` since `es6` is required for `@types/google-protobuf`.
    system "tsc", "--lib", "es6", "test.ts"
  end
end

__END__
diff --git a/javascript/net/grpc/web/generator/grpc_generator.cc b/javascript/net/grpc/web/generator/grpc_generator.cc
index 158a335bb..1eb97b35d 100644
--- a/javascript/net/grpc/web/generator/grpc_generator.cc
+++ b/javascript/net/grpc/web/generator/grpc_generator.cc
@@ -841,13 +841,11 @@ void PrintProtoDtsMessage(Printer* printer, const Descriptor* desc,
                      "set$js_field_name$(value?: $js_field_type$): "
                      "$class_name$;\n");
     }
-    if (field->has_optional_keyword() ||
-        (field->type() == FieldDescriptor::TYPE_MESSAGE &&
-            !field->is_repeated() && !field->is_map())) {
+    if (field->has_presence()) {
       printer->Print(vars, "has$js_field_name$(): boolean;\n");
     }
-    if (field->type() == FieldDescriptor::TYPE_MESSAGE || field->has_optional_keyword() ||
-        field->is_repeated() || field->is_map()) {
+    if (field->type() == FieldDescriptor::TYPE_MESSAGE ||
+        field->has_presence() || field->is_repeated() || field->is_map()) {
       printer->Print(vars, "clear$js_field_name$(): $class_name$;\n");
     }
     if (field->is_repeated() && !field->is_map()) {
@@ -867,14 +865,12 @@ void PrintProtoDtsMessage(Printer* printer, const Descriptor* desc,
     printer->Print("\n");
   }

-  for (int i = 0; i < desc->oneof_decl_count(); i++) {
-    const OneofDescriptor* oneof = desc->oneof_decl(i);
-    if (!oneof->is_synthetic()) {
-      vars["js_oneof_name"] = ToUpperCamel(ParseLowerUnderscore(oneof->name()));
-      printer->Print(
-          vars, "get$js_oneof_name$Case(): $class_name$.$js_oneof_name$Case;\n");
-      printer->Print("\n");
-    }
+  for (int i = 0; i < desc->real_oneof_decl_count(); i++) {
+    const OneofDescriptor *oneof = desc->real_oneof_decl(i);
+    vars["js_oneof_name"] = ToUpperCamel(ParseLowerUnderscore(oneof->name()));
+    printer->Print(
+        vars, "get$js_oneof_name$Case(): $class_name$.$js_oneof_name$Case;\n");
+    printer->Print("\n");
   }

   printer->Print(
@@ -904,8 +900,7 @@ void PrintProtoDtsMessage(Printer* printer, const Descriptor* desc,
     }
     vars["js_field_name"] = js_field_name;
     vars["js_field_type"] = AsObjectFieldType(field, file);
-    if ((field->type() != FieldDescriptor::TYPE_MESSAGE && !field->has_optional_keyword()) ||
-        field->is_repeated()) {
+    if (!field->has_presence()) {
       printer->Print(vars, "$js_field_name$: $js_field_type$,\n");
     } else {
       printer->Print(vars, "$js_field_name$?: $js_field_type$,\n");