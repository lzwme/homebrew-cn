class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https:www.sonatype.com"
  url "https:github.comsonatypenexus-publicarchiverefstagsrelease-3.76.1-01.tar.gz"
  sha256 "e2fe13994f4ffcc3e5389ea90e14a1dcc7af92ce37015a961f89bbf151d29c86"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "283afcee917edb48dc89401fbde2f2e2e7ef6f4f3a4b2f0c0aeb1a13977482c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11fc02e55b326e2d714610e13cddc965cf404eb7e9a94d33789676bc03076670"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "824cffac4a9810625e41bc140f5656bfaa255851c0b6a475374daf1b5503b906"
    sha256 cellar: :any_skip_relocation, sonoma:        "03908a16b05b89f03316b1d2113f7f9b0d23e35c8b362fca047af78b0577e806"
    sha256 cellar: :any_skip_relocation, ventura:       "17e647b341d6e2d8e8d5b55695403320eb099f7d7708b56a349e8ab4d76f5a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d153097684ef3d932e1c2ed8c77113a12a1102c9c60f862acbb7ada2b8ef33"
  end

  depends_on "maven" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "openjdk@17"

  uses_from_macos "unzip" => :build

  # Avoid downloading copies of node and yarn
  patch :DATA

  def install
    # Workaround build error: Couldn't find package "@sonatypenexus-ui-plugin@workspace:*"
    # Ref: https:github.comsonatypenexus-publicissues417
    # Ref: https:github.comsonatypenexus-publicissues432#issuecomment-2663250153
    inreplace ["componentsnexus-rapturepackage.json", "pluginsnexus-coreui-pluginpackage.json"],
              '"@sonatypenexus-ui-plugin": "workspace:*"',
              '"@sonatypenexus-ui-plugin": "*"'

    java_version = "17"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    java_env = Language::Java.overridable_java_home_env(java_version)
    java_env.merge!(KARAF_DATA: "${NEXUS_KARAF_DATA:-#{var}nexus}",
                    KARAF_LOG:  var"lognexus",
                    KARAF_ETC:  pkgetc)

    with_env(SKIP_YARN_COREPACK_CHECK: "1") do
      system "yarn", "install", "--immutable"
      system "yarn", "workspaces", "run", "build-all"
    end

    system "mvn", "install", "-DskipTests", "-Dpublic"
    system "unzip", "-o", "-d", "target", "assembliesnexus-base-templatetargetnexus-base-template-#{version}.zip"

    rm(Dir["targetnexus-base-template-#{version}bin*.bat"])
    rm_r("targetnexus-base-template-#{version}bincontrib")
    libexec.install Dir["targetnexus-base-template-#{version}*"]
    (bin"nexus").write_env_script libexec"binnexus", java_env
  end

  def post_install
    (var"lognexus").mkpath unless (var"lognexus").exist?
    (var"nexus").mkpath unless (var"nexus").exist?
    pkgetc.mkpath unless pkgetc.exist?
  end

  service do
    run [opt_bin"nexus", "start"]
  end

  test do
    port = free_port
    (testpath"dataetcnexus.properties").write "application-port=#{port}"
    pid = spawn({ "NEXUS_KARAF_DATA" => testpath"data" }, bin"nexus", "server")
    sleep 50
    sleep 50 if OS.mac? && Hardware::CPU.intel?
    assert_match "<title>Sonatype Nexus Repository<title>", shell_output("curl --silent --fail http:localhost:#{port}")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end

__END__
diff --git apluginsnexus-coreui-pluginpom.xml bpluginsnexus-coreui-pluginpom.xml
index 9b8325fd98..2a58a07afe 100644
--- apluginsnexus-coreui-pluginpom.xml
+++ bpluginsnexus-coreui-pluginpom.xml
@@ -172,7 +172,7 @@
         <artifactId>karaf-maven-plugin<artifactId>
       <plugin>
 
-      <plugin>
+      <!--plugin>
         <groupId>com.github.eirslett<groupId>
         <artifactId>frontend-maven-plugin<artifactId>
 
@@ -212,12 +212,12 @@
             <goals>
             <phase>test<phase>
             <configuration>
-              <arguments>test --reporters=jest-junit --reporters=default<arguments>
+              <arguments>test -reporters=jest-junit -reporters=default<arguments>
               <skip>${npm.skipTests}<skip>
             <configuration>
           <execution>
         <executions>
-      <plugin>
+      <plugin-->
     <plugins>
   <build>
 
diff --git apom.xml bpom.xml
index 6647497628..d99148b421 100644
--- apom.xml
+++ bpom.xml
@@ -877,7 +877,7 @@
           <executions>
         <plugin>
 
-        <plugin>
+        <!--plugin>
           <groupId>com.github.eirslett<groupId>
           <artifactId>frontend-maven-plugin<artifactId>
           <version>1.11.3<version>
@@ -932,7 +932,7 @@
               <configuration>
             <execution>
           <executions>
-        <plugin>
+        <plugin-->
 
         <plugin>
           <groupId>com.mycila<groupId>