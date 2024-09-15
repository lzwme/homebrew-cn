class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https:github.comgrpcgrpc-web"
  url "https:github.comgrpcgrpc-webarchiverefstags1.5.0.tar.gz"
  sha256 "d3043633f1c284288e98e44c802860ca7203c7376b89572b5f5a9e376c2392d5"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "81c62df049e3dc2f40c57850ebac6c6d67894be6592ba9c35a142660201cc5cf"
    sha256 cellar: :any,                 arm64_sonoma:  "fa2b811d414cdc773dca6de733fe70649482a5d7b06fa773fa97c7d1bfc21175"
    sha256 cellar: :any,                 arm64_ventura: "98b66e607aaac19db91c663ed6cba9c92577cf5afca4fcb0d1a0a4710c22a5a1"
    sha256 cellar: :any,                 sonoma:        "b8d373f42bee31253c7159e9cb4c0943c023b319bdea6a40a9db8e38304d8904"
    sha256 cellar: :any,                 ventura:       "67d644faa5497cfe145cd29f028e1ee52f35e5d762742c7d22b8f1aa8a097e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2dc87a12c5ebf6a6a251fdbf6081bbaaf97b7224b9c049051242eb82fe16e27"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf"
  depends_on "protoc-gen-js"

  # Backport of https:github.comgrpcgrpc-webcommit2c39859be8e5bcf55eef129e5a5330149ce460ab
  patch :DATA

  def install
    # Workarounds to build with latest `protobuf` which needs Abseil link flags and C++17
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkg-config", "--libs", "protobuf").chomp
    inreplace "javascriptnetgrpcwebgeneratorMakefile", "-std=c++11", "-std=c++17"

    args = ["PREFIX=#{prefix}", "STATIC=no"]
    args << "MIN_MACOS_VERSION=#{MacOS.version}" if OS.mac?

    system "make", "install-plugin", *args
  end

  test do
    # First use the plugin to generate the files.
    testdata = <<~EOS
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
    EOS
    (testpath"test.proto").write testdata
    system "protoc", "test.proto", "--plugin=#{bin}protoc-gen-grpc-web",
                     "--js_out=import_style=commonjs:.",
                     "--grpc-web_out=import_style=typescript,mode=grpcwebtext:."

    # Now see if we can import them.
    testts = <<~EOS
      import * as grpcWeb from 'grpc-web';
      import {TestServiceClient} from '.TestServiceClientPb';
      import {Test, TestResult} from '.test_pb';
    EOS
    (testpath"test.ts").write testts
    system "npm", "install", *std_npm_args(prefix: false), "grpc-web", "@typesgoogle-protobuf"
    # Specify including lib for `tsc` since `es6` is required for `@typesgoogle-protobuf`.
    system "tsc", "--lib", "es6", "test.ts"
  end
end

__END__
diff --git ajavascriptnetgrpcwebgeneratorgrpc_generator.cc bjavascriptnetgrpcwebgeneratorgrpc_generator.cc
index 158a335bb..1eb97b35d 100644
--- ajavascriptnetgrpcwebgeneratorgrpc_generator.cc
+++ bjavascriptnetgrpcwebgeneratorgrpc_generator.cc
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