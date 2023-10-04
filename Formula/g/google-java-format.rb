class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://ghproxy.com/https://github.com/google/google-java-format/releases/download/v1.18.0/google-java-format-1.18.0-all-deps.jar"
  sha256 "ec401485fc9a95569d81dc59ce971ec5a0e6eda7f334e949a916fe9ae056e66b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1995c4537ec832953aa99feb5fd1db19a8212eecbe04b735118bd1d0e8e6392b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1995c4537ec832953aa99feb5fd1db19a8212eecbe04b735118bd1d0e8e6392b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1995c4537ec832953aa99feb5fd1db19a8212eecbe04b735118bd1d0e8e6392b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1995c4537ec832953aa99feb5fd1db19a8212eecbe04b735118bd1d0e8e6392b"
    sha256 cellar: :any_skip_relocation, ventura:        "1995c4537ec832953aa99feb5fd1db19a8212eecbe04b735118bd1d0e8e6392b"
    sha256 cellar: :any_skip_relocation, monterey:       "1995c4537ec832953aa99feb5fd1db19a8212eecbe04b735118bd1d0e8e6392b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e1877c72693357457d9e0ec4f214c0e12cf8e354fec7905740ad19dae737d51"
  end

  depends_on "openjdk"
  depends_on "python@3.11"

  resource "google-java-format-diff" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/google/google-java-format/v1.18.0/scripts/google-java-format-diff.py"
    sha256 "4c46a4ed6c39c2f7cbf2bc7755eefd7eaeb0a3db740ed1386053df822f15782b"
  end

  def install
    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec/"google-java-format.jar", "google-java-format"
    resource("google-java-format-diff").stage do
      bin.install "google-java-format-diff.py" => "google-java-format-diff"
      rewrite_shebang detected_python_shebang, bin/"google-java-format-diff"
    end
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
    (testpath/"bar.java").write <<~BAR
      class Bar{
        int  x;
      }
    BAR
    patch = <<~PATCH
      --- a/bar.java
      +++ b/bar.java
      @@ -1,0 +2 @@ class Bar{
      +  int x  ;
    PATCH
    `echo '#{patch}' | #{bin}/google-java-format-diff -p1 -i`
    assert_equal <<~BAR, File.read(testpath/"bar.java")
      class Bar{
        int x;
      }
    BAR
    assert_equal version, resource("google-java-format-diff").version
  end
end