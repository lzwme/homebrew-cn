class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://ghfast.top/https://github.com/google/google-java-format/releases/download/v1.37.0/google-java-format-1.37.0-all-deps.jar"
  sha256 "834b2a0c38cb774953322a84b5ca3f2f40dd3156650b3cd44d3b744345962f7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "faa9328f469dba1c75a36cf9d889d30c3d17a4b65e487087613c3479012cfe4a"
  end

  depends_on "openjdk"

  uses_from_macos "python"

  resource "google-java-format-diff" do
    url "https://ghfast.top/https://raw.githubusercontent.com/google/google-java-format/v1.37.0/scripts/google-java-format-diff.py"
    sha256 "9fa04c5dd3b10ed48a02b319afab116a79a31f5ba3b27ed4b3549dd20eafc04a"

    livecheck do
      formula :parent
    end
  end

  def install
    if version != resource("google-java-format-diff").version
      odie "google-java-format-diff resource needs to be updated"
    end

    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec/"google-java-format.jar", "google-java-format"
    resource("google-java-format-diff").stage do
      rewrite_shebang detected_python_shebang(use_python_from_path: true), "google-java-format-diff.py"
      bin.install "google-java-format-diff.py" => "google-java-format-diff"
    end
  end

  test do
    (testpath/"foo.java").write <<~JAVA
      public class Foo{
      }
    JAVA

    (testpath/"bar.java").write <<~JAVA
      class Bar{
        int  x;
      }
    JAVA

    patch = <<~DIFF
      --- a/bar.java
      +++ b/bar.java
      @@ -1,0 +2 @@ class Bar{
      +  int x  ;
    DIFF

    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
    assert_empty pipe_output("#{bin}/google-java-format-diff -p1 -i", patch)
    assert_equal <<~JAVA, (testpath/"bar.java").read
      class Bar{
        int x;
      }
    JAVA
  end
end