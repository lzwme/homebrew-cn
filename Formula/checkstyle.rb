class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://ghproxy.com/https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.8.0/checkstyle-10.8.0-all.jar"
  sha256 "81671e9c529ca930e0d4b7770f8d3e75bc3e703e103b6246ff705ca25d808fa7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fd3258179551c9971c5043434044862e3fc08fdc134017a75cdd1e5a4f79e6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fd3258179551c9971c5043434044862e3fc08fdc134017a75cdd1e5a4f79e6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fd3258179551c9971c5043434044862e3fc08fdc134017a75cdd1e5a4f79e6c"
    sha256 cellar: :any_skip_relocation, ventura:        "1fd3258179551c9971c5043434044862e3fc08fdc134017a75cdd1e5a4f79e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd3258179551c9971c5043434044862e3fc08fdc134017a75cdd1e5a4f79e6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fd3258179551c9971c5043434044862e3fc08fdc134017a75cdd1e5a4f79e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ddb9f6ea8ab72e71c8af5c830d4823de5fda12f891c171b2abcd280e8ccc77"
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