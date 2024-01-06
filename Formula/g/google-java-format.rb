class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https:github.comgooglegoogle-java-format"
  url "https:github.comgooglegoogle-java-formatreleasesdownloadv1.19.2google-java-format-1.19.2-all-deps.jar"
  sha256 "d898b5f70c55afdcf7c0431e497d68a48472c384f2d04fe6f0978dffe62cbe2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2130cc979d712607ad83a8e86da215c075c762ce3ce745bf13557b8910488010"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  resource "google-java-format-diff" do
    url "https:raw.githubusercontent.comgooglegoogle-java-formatv1.19.2scriptsgoogle-java-format-diff.py"
    sha256 "aa9621c0f0859e1112231a7d44ce8d21854f6915ca643a0d53a119f4d1aa8488"
  end

  def install
    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec"google-java-format.jar", "google-java-format"
    resource("google-java-format-diff").stage do
      bin.install "google-java-format-diff.py" => "google-java-format-diff"
      rewrite_shebang detected_python_shebang, bin"google-java-format-diff"
    end
  end

  test do
    (testpath"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}google-java-format foo.java")
    (testpath"bar.java").write <<~BAR
      class Bar{
        int  x;
      }
    BAR
    patch = <<~PATCH
      --- abar.java
      +++ bbar.java
      @@ -1,0 +2 @@ class Bar{
      +  int x  ;
    PATCH
    `echo '#{patch}' | #{bin}google-java-format-diff -p1 -i`
    assert_equal <<~BAR, File.read(testpath"bar.java")
      class Bar{
        int x;
      }
    BAR
    assert_equal version, resource("google-java-format-diff").version
  end
end