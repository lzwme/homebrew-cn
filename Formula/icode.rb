class Icode < Formula
  desc "CNES static code analysis tool"
  homepage "https://github.com/cnescatlab/i-CodeCNES"
  url "https://ghproxy.com/https://github.com/cnescatlab/i-CodeCNES/releases/download/4.1.2/icode-4.1.2.zip"
  sha256 "853fcafe9e1df1546034104e9475f966bdedfff82dfef3950f293e95bf0ff806"
  license "EPL-1.0"

  depends_on "openjdk"

  def install
    system "chmod", "+x", "icode"
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/icode") do |file|
      basename = "" + file.basename
      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end

  def test
    system "#{bin}/icode", "--version"
  end
end