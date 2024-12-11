class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https:github.comgooglegoogle-java-format"
  url "https:github.comgooglegoogle-java-formatreleasesdownloadv1.25.1google-java-format-1.25.1-all-deps.jar"
  sha256 "0f581fe962d18eef89d8751e215a9f62c50dbf6eda430893fc482daa65cb93ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a5a1f8927d45c7c481995cf189b6f44a01f85f5a4e7e96e8cf1b081f04dc1da8"
  end

  depends_on "openjdk"

  uses_from_macos "python", since: :catalina

  resource "google-java-format-diff" do
    url "https:raw.githubusercontent.comgooglegoogle-java-formatv1.25.1scriptsgoogle-java-format-diff.py"
    sha256 "c1f2c6e8af0fc34a04adfcb01b35e522a359df5da1f5db5102ca9e0ca1f670fd"
  end

  def install
    if version != resource("google-java-format-diff").version
      odie "google-java-format-diff resource needs to be updated"
    end

    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec"google-java-format.jar", "google-java-format"
    resource("google-java-format-diff").stage do
      rewrite_shebang detected_python_shebang(use_python_from_path: true), "google-java-format-diff.py"
      bin.install "google-java-format-diff.py" => "google-java-format-diff"
    end
  end

  test do
    (testpath"foo.java").write <<~JAVA
      public class Foo{
      }
    JAVA

    (testpath"bar.java").write <<~JAVA
      class Bar{
        int  x;
      }
    JAVA

    patch = <<~DIFF
      --- abar.java
      +++ bbar.java
      @@ -1,0 +2 @@ class Bar{
      +  int x  ;
    DIFF

    assert_match "public class Foo {}", shell_output("#{bin}google-java-format foo.java")
    assert_empty pipe_output("#{bin}google-java-format-diff -p1 -i", patch)
    assert_equal <<~JAVA, (testpath"bar.java").read
      class Bar{
        int x;
      }
    JAVA
  end
end