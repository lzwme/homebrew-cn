class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https:checkstyle.sourceforge.io"
  url "https:github.comcheckstylecheckstylereleasesdownloadcheckstyle-10.14.1checkstyle-10.14.1-all.jar"
  sha256 "5e003cab32c19af85b62ae9ce9607c623f72b9db4aac54b7c216e6a1b540b360"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f698b8defcd9c992da0757adfc91f077abe4b1404977edbdcf6e7bf093545b8c"
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