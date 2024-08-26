class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https:checkstyle.sourceforge.io"
  url "https:github.comcheckstylecheckstylereleasesdownloadcheckstyle-10.18.0checkstyle-10.18.0-all.jar"
  sha256 "7048c0737422227e6fa34b322e8e095414e5645fb93e82411d8a7cb2492d4bea"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c975e93c9bb6242a66257328838f534b4769340c969e19f8afbc42cb1b50ff25"
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