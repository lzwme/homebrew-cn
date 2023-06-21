class Mvnvm < Formula
  desc "Maven version manager"
  homepage "https://mvnvm.org/"
  url "https://bitbucket.org/mjensen/mvnvm/get/mvnvm-1.0.22.tar.gz"
  sha256 "309c49d1c45910560296e4540ab2544327a7129738a78837e4a05528f5d2d459"
  license "Apache-2.0"
  head "https://bitbucket.org/mjensen/mvnvm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53a0e70d81fe15c525dd0532f31fa39887f27ca649946872d5d02fad928320f8"
  end

  deprecate! date: "2023-06-19", because: :repo_removed

  depends_on "openjdk"

  conflicts_with "maven", because: "also installs a 'mvn' executable"

  def install
    bin.install "mvn"
    bin.install "mvnDebug"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"settings.xml").write <<~EOS
      <settings><localRepository>#{testpath}/repository</localRepository></settings>
    EOS
    (testpath/"mvnvm.properties").write <<~EOS
      mvn_version=3.5.2
    EOS
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
    system "#{bin}/mvn", "-gs", "#{testpath}/settings.xml", "compile"
  end
end