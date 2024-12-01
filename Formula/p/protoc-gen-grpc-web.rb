class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https:github.comgrpcgrpc-web"
  url "https:github.comgrpcgrpc-webarchiverefstags1.5.0.tar.gz"
  sha256 "d3043633f1c284288e98e44c802860ca7203c7376b89572b5f5a9e376c2392d5"
  license "Apache-2.0"
  revision 5

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5858eb1092a756c8f54e8ea94ab2dc35f9b9db55f3245c7d6b1c778c0c61d380"
    sha256 cellar: :any,                 arm64_sonoma:  "135a6e18d0426437275d2f6498d725b220a3cc0ef99c6ba6515520f60df512b2"
    sha256 cellar: :any,                 arm64_ventura: "8e651f4b9e5bb2f6ba9f0a075569723e114ba0feb726439c5b3f3481252ee343"
    sha256 cellar: :any,                 sonoma:        "cac5a2076240c24569795fa36eda1dcd1769d81d61ba37d163fb59859941be44"
    sha256 cellar: :any,                 ventura:       "c80bb03b433945b6e6ac21985dfa6506d59b845a68f9003ea737239a163b7a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b87de89d281c7398eb9be9386ccc8cf55d88953249be16157852867b5d34d5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf"
  depends_on "protoc-gen-js"

  # Backport of https:github.comgrpcgrpc-webcommit2c39859be8e5bcf55eef129e5a5330149ce460ab
  patch :DATA

  def install
    # Workarounds to build with latest `protobuf` which needs Abseil link flags and C++17
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp
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
    (testpath"test.ts").write <<~TYPESCRIPT
      import * as grpcWeb from 'grpc-web';
      import {TestServiceClient} from '.TestServiceClientPb';
      import {Test, TestResult} from '.test_pb';
    TYPESCRIPT
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