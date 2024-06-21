class Mvnvm < Formula
  desc "Maven version manager"
  # upstream homepage bug report, https://bitbucket.org/mjensen/mvnvm/issues/41/https-mvnvmorg-is-not-reachable
  homepage "https://bitbucket.org/mjensen/mvnvm/"
  url "https://bitbucket.org/mjensen/mvnvm/get/mvnvm-1.0.28.tar.gz"
  sha256 "0f0cb35c70d47404f0713e19fe625c28fce04f7b4b9b9302b655a306ada2755d"
  license "Apache-2.0"
  head "https://bitbucket.org/mjensen/mvnvm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3adbd5be39a2aa867449bea8686dd3b55b451cdf18a4b4303b0bbcc19b507c52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3adbd5be39a2aa867449bea8686dd3b55b451cdf18a4b4303b0bbcc19b507c52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3adbd5be39a2aa867449bea8686dd3b55b451cdf18a4b4303b0bbcc19b507c52"
    sha256 cellar: :any_skip_relocation, sonoma:         "3adbd5be39a2aa867449bea8686dd3b55b451cdf18a4b4303b0bbcc19b507c52"
    sha256 cellar: :any_skip_relocation, ventura:        "3adbd5be39a2aa867449bea8686dd3b55b451cdf18a4b4303b0bbcc19b507c52"
    sha256 cellar: :any_skip_relocation, monterey:       "3adbd5be39a2aa867449bea8686dd3b55b451cdf18a4b4303b0bbcc19b507c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "494854b1b1051b9e45fc86a28d68978601043bd848000d9767c67bbdeae235db"
  end

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