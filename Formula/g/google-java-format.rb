class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://ghfast.top/https://github.com/google/google-java-format/releases/download/v1.28.0/google-java-format-1.28.0-all-deps.jar"
  sha256 "32342e7c1b4600f80df3471da46aee8012d3e1445d5ea1be1fb71289b07cc735"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e06153707967aed9b949074872dcf84b08a5a94432a1e47058743e1a5a66cc97"
  end

  depends_on "openjdk"

  uses_from_macos "python"

  resource "google-java-format-diff" do
    url "https://ghfast.top/https://raw.githubusercontent.com/google/google-java-format/v1.28.0/scripts/google-java-format-diff.py"
    sha256 "c1f2c6e8af0fc34a04adfcb01b35e522a359df5da1f5db5102ca9e0ca1f670fd"
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