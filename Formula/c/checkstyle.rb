class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https:checkstyle.sourceforge.io"
  url "https:github.comcheckstylecheckstylereleasesdownloadcheckstyle-10.17.0checkstyle-10.17.0-all.jar"
  sha256 "51c34d738520c1389d71998a9ab0e6dabe0d7cf262149f3e01a7294496062e42"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7b95785e0c51a0c6f65abb9a2a25b6c7f72547573d46cea8b64e8bd5b991e076"
  end

  depends_on "openjdk"

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath"foo.java"
    path.write "public class Foo{ }\n"

    output = shell_output("#{bin}checkstyle -c sun_checks.xml #{path}", 2)
    errors = output.lines.select { |line| line.start_with?("[ERROR] #{path}") }
    assert_match "#{path}:1:17: '{' is not preceded with whitespace.", errors.join(" ")
    assert_equal errors.size, $CHILD_STATUS.exitstatus
  end
end