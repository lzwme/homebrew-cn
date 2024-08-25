class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https:github.comgooglegoogle-java-format"
  url "https:github.comgooglegoogle-java-formatreleasesdownloadv1.23.0google-java-format-1.23.0-all-deps.jar"
  sha256 "7c6375ac24b4825be6bbe61900e8b58b1a3e8944a1367a8363210f9ed2d08570"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e847294783d52ea08347896a1f108e722ad673e0b12f701d07226a021b39c621"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  resource "google-java-format-diff" do
    url "https:raw.githubusercontent.comgooglegoogle-java-formatv1.23.0scriptsgoogle-java-format-diff.py"
    sha256 "c1f2c6e8af0fc34a04adfcb01b35e522a359df5da1f5db5102ca9e0ca1f670fd"
  end

  def install
    if version != resource("google-java-format-diff").version
      odie "google-java-format-diff resource needs to be updated"
    end

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
  end
end