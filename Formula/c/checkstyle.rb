class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https:checkstyle.sourceforge.io"
  url "https:github.comcheckstylecheckstylereleasesdownloadcheckstyle-10.21.3checkstyle-10.21.3-all.jar"
  sha256 "24fe33442f221364f4f63bb6313e42f80b3b559d0b8942e40c699b20557e5816"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09c3a246e572b8b231b8299d99ca027c70352b5cae9ddc1a937d6750863b1d07"
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