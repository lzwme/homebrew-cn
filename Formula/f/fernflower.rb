class Fernflower < Formula
  desc "Advanced decompiler for Java bytecode"
  homepage "https://github.com/JetBrains/fernflower"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  url "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/252.26830.84/java-decompiler-engine-252.26830.84.jar"
  sha256 "d41310023d74a5c4a89d4fc7202f47ddc1a2770da4807b1752453813904ae010"
  license "Apache-2.0"

  livecheck do
    url "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f03bd3669b7e23b0d402b69410f984044f8493821ad4ca16261229abb5daf27"
  end

  depends_on "openjdk"

  def install
    libexec.install "java-decompiler-engine-#{version}.jar"
    bin.write_jar_script libexec/"java-decompiler-engine-#{version}.jar", "fernflower"
  end

  test do
    (testpath/"Main.java").write <<~JAVA
      void main() {
        IO.println("hello world");
      }
    JAVA

    system Formula["openjdk"].opt_bin/"javac", "Main.java"
    (testpath/"out").mkpath
    system bin/"fernflower", "Main.class", "out"

    output = (testpath/"out/Main.java").read.strip
    expected = <<~JAVA.strip
      final class Main {
         void main() {
            IO.println("hello world");
         }
      }
    JAVA

    assert_equal expected, output
  end
end