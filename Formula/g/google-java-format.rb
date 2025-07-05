class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://ghfast.top/https://github.com/google/google-java-format/releases/download/v1.27.0/google-java-format-1.27.0-all-deps.jar"
  sha256 "ed07239f3cb72e25bf2a0eae63e76831f9f11963bd19fc36a6f1d87016ac1763"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "70d76d7e24a7b311e1aec5c68757f13d14c801c15bc3e158e2978ae3ddd18cc3"
  end

  depends_on "openjdk"

  uses_from_macos "python", since: :catalina

  resource "google-java-format-diff" do
    url "https://ghfast.top/https://raw.githubusercontent.com/google/google-java-format/v1.27.0/scripts/google-java-format-diff.py"
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