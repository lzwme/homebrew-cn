class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://ghproxy.com/https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.5/checkstyle-10.12.5-all.jar"
  sha256 "0c050f9e04cbf5cd8c78f1b92122ee97e891be7c2a0a1834e1fa3adda28079ed"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e693e482e0b6125aef9c11534e6677f0a2ad3a42876118c784b497ec2bbf6532"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e693e482e0b6125aef9c11534e6677f0a2ad3a42876118c784b497ec2bbf6532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e693e482e0b6125aef9c11534e6677f0a2ad3a42876118c784b497ec2bbf6532"
    sha256 cellar: :any_skip_relocation, sonoma:         "e693e482e0b6125aef9c11534e6677f0a2ad3a42876118c784b497ec2bbf6532"
    sha256 cellar: :any_skip_relocation, ventura:        "e693e482e0b6125aef9c11534e6677f0a2ad3a42876118c784b497ec2bbf6532"
    sha256 cellar: :any_skip_relocation, monterey:       "e693e482e0b6125aef9c11534e6677f0a2ad3a42876118c784b497ec2bbf6532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "424adb21361ee3d27b326b0484e42d6cc5a737ac7c4853e58c5abdaac77a036b"
  end

  depends_on "openjdk"

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = shell_output("#{bin}/checkstyle -c /sun_checks.xml #{path}", 2)
    errors = output.lines.select { |line| line.start_with?("[ERROR] #{path}") }
    assert_match "#{path}:1:17: '{' is not preceded with whitespace.", errors.join(" ")
    assert_equal errors.size, $CHILD_STATUS.exitstatus
  end
end