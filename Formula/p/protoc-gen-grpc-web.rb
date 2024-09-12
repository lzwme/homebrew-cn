class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https:github.comgrpcgrpc-web"
  url "https:github.comgrpcgrpc-webarchiverefstags1.5.0.tar.gz"
  sha256 "d3043633f1c284288e98e44c802860ca7203c7376b89572b5f5a9e376c2392d5"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a1380447c6c7998f1346501536727e5806611c4892671851c100ef7f242a8ce1"
    sha256 cellar: :any,                 arm64_sonoma:   "f75cc8466c6773885059bd615d775c917a64388d3208e18e99fc745857efb271"
    sha256 cellar: :any,                 arm64_ventura:  "8b7d340837605b8088c123067a58d0548dec600ce53d63ff1cd65c3f7d050b61"
    sha256 cellar: :any,                 arm64_monterey: "6d95c1d15884fdeb7fff0765a9cc927f4ee29533671f4ad64c284600ae59604b"
    sha256 cellar: :any,                 sonoma:         "03a722484f5c9851b7943e8ee73489150a3d5c7a2647aab541ef5a13b271db59"
    sha256 cellar: :any,                 ventura:        "7171ba31b7089bca1a6b81ebb536eddc8a951bae4363f1d220f0237278630d58"
    sha256 cellar: :any,                 monterey:       "6faa85430a15cb6ea6619a1d90bc0a8965a619d1041f86e58c3930395b36c200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "badb7f248c73143316ed40614abf5717d3ca676f152fb6461da630a0fb72368d"
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