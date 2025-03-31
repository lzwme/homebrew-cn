class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https:checkstyle.sourceforge.io"
  url "https:github.comcheckstylecheckstylereleasesdownloadcheckstyle-10.22.0checkstyle-10.22.0-all.jar"
  sha256 "53a4290128022b1bf735314836427d01ecb813d634f3d458e57d933614a520eb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65a72dc42fe4425369f0781be068e79501dfb9d8127d158e48caa43530a95e0b"
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