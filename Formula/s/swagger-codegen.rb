class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.70.tar.gz"
  sha256 "d7e13130abe3405d847a2cdb6f2a67d4bef6c157f159b9da1aefbc988d523319"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9e7fb513db8bf4f2bfca2ae59a7307f4a12316644e19357342b7b959c4edff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "529e75878d6a9f86f2a1e0e460cebffe4e81e1d27586866710662b443755d9fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b757fd6cbd73b3c3d9f66c24171f6d7680c1a364d5be2846fdccb1c898ec62e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b5464b4b35a6020bfa9a3ec4a75999b2be93dc063e353bf1f05dc2db6263693"
    sha256 cellar: :any_skip_relocation, ventura:       "49338a108b9974fab989065bbfb1a2a7ed8186f4c42fa10967d1cc9c46058f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f95b75dc91dd7f77c5f8243179d8ffce17db219a52a596797e16744e6f64dbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9876cd3f5cc8ee01dcaa7962de6c92b9e428cbd204f3c777d0f7450075f7c62"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  # patch swagger-codegen-generators version, upstream issue, https:github.comswagger-apiswagger-codegenissues12573
  patch :DATA

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "clean", "package"
    libexec.install "modulesswagger-codegen-clitargetswagger-codegen-cli.jar"
    bin.write_jar_script libexec"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath"minimal.yaml").write <<~YAML
      ---
      openapi: 3.0.0
      info:
        version: 0.0.0
        title: Simple API
      paths:
        :
          get:
            responses:
              200:
                description: OK
    YAML
    system bin"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath"index.html"), "<h1>Simple API<h1>"
  end
end

__END__
diff --git apom.docker.xml bpom.docker.xml
index f893961..aa9fbf6 100644
--- apom.docker.xml
+++ bpom.docker.xml
@@ -1107,7 +1107,7 @@
     <dependencyManagement>
     <properties>
         <maven.compiler.release>8<maven.compiler.release>
-        <swagger-codegen-generators-version>1.0.58-SNAPSHOT<swagger-codegen-generators-version>
+        <swagger-codegen-generators-version>1.0.57<swagger-codegen-generators-version>
         <swagger-core-version>2.2.28<swagger-core-version>
         <swagger-core-version-v1>1.6.15<swagger-core-version-v1>
         <swagger-parser-version>2.1.25<swagger-parser-version>
diff --git apom.xml bpom.xml
index b46c57d..6690405 100644
--- apom.xml
+++ bpom.xml
@@ -1208,7 +1208,7 @@
     <dependencyManagement>
     <properties>
         <maven.compiler.release>8<maven.compiler.release>
-        <swagger-codegen-generators-version>1.0.58-SNAPSHOT<swagger-codegen-generators-version>
+        <swagger-codegen-generators-version>1.0.57<swagger-codegen-generators-version>
         <swagger-core-version>2.2.28<swagger-core-version>
         <swagger-core-version-v1>1.6.15<swagger-core-version-v1>
         <swagger-parser-version>2.1.25<swagger-parser-version>
diff --git asamplesmeta-codegenpom.xml bsamplesmeta-codegenpom.xml
index a0074a4..480530c 100644
--- asamplesmeta-codegenpom.xml
+++ bsamplesmeta-codegenpom.xml
@@ -121,7 +121,7 @@
     <properties>
         <project.build.sourceEncoding>UTF-8<project.build.sourceEncoding>
         <swagger-codegen-version>3.0.70<swagger-codegen-version>
-        <swagger-codegen-generators-version>1.0.58-SNAPSHOT<swagger-codegen-generators-version>
+        <swagger-codegen-generators-version>1.0.57<swagger-codegen-generators-version>
         <maven-plugin-version>1.0.0<maven-plugin-version>
         <junit-version>4.13.2<junit-version>
         <build-helper-maven-plugin>3.0.0<build-helper-maven-plugin>