class Icode < Formula
  desc "CNES static code analysis tool"
  homepage "https:github.comcnescatlabi-CodeCNES"
  url "https:github.comcnescatlabi-CodeCNESreleasesdownload4.1.2icode-4.1.2.zip"
  sha256 "853fcafe9e1df1546034104e9475f966bdedfff82dfef3950f293e95bf0ff806"
  license "EPL-1.0"

  livecheck do
    url :stable
    strategy :github_releases
  end

  depends_on "openjdk"

  def install
    chmod("+x", "icode")
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}icode") do |file|
      basename = "" + file.basename
      (binbasename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end

  test do
    system bin"icode", "--version"
  end
end