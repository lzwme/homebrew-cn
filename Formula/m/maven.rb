class Maven < Formula
  desc "Java-based project management"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz"
  sha256 "067672629075b740e3d0a928e21021dd615a53287af36d4ccca44e87e081d102"
  license "Apache-2.0"

  livecheck do
    url "https://maven.apache.org/download.cgi"
    regex(/href=.*?apache-maven[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99e7bbc92e3c9e8b835c0edac7194167c88133fa8a22ef3b5a0ee8c82a30b154"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99e7bbc92e3c9e8b835c0edac7194167c88133fa8a22ef3b5a0ee8c82a30b154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99e7bbc92e3c9e8b835c0edac7194167c88133fa8a22ef3b5a0ee8c82a30b154"
    sha256 cellar: :any_skip_relocation, sonoma:         "341f0cc0aa427ccfb068872ab6b262af45334f35ac46d00639fdd76f7dc0a094"
    sha256 cellar: :any_skip_relocation, ventura:        "341f0cc0aa427ccfb068872ab6b262af45334f35ac46d00639fdd76f7dc0a094"
    sha256 cellar: :any_skip_relocation, monterey:       "341f0cc0aa427ccfb068872ab6b262af45334f35ac46d00639fdd76f7dc0a094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7e3cd2dd6b4ed2638da86882a56bd6d0e5b60d9f8e3edf933041c08e7094eb7"
  end

  depends_on "openjdk"

  conflicts_with "mvnvm", because: "also installs a 'mvn' executable"

  def install
    # Remove windows files
    rm_f Dir["bin/*.cmd"]

    # Fix the permissions on the global settings file.
    chmod 0644, "conf/settings.xml"

    libexec.install Dir["*"]

    # Leave conf file in libexec. The mvn symlink will be resolved and the conf
    # file will be found relative to it
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "m2.conf"

      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath/"pom.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="https://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <properties>
          <maven.compiler.source>1.8</maven.compiler.source>
          <maven.compiler.target>1.8</maven.compiler.target>
          <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        </properties>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<~EOS
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    EOS
    system "#{bin}/mvn", "compile", "-Duser.home=#{testpath}"
  end
end