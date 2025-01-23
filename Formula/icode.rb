class Icode < Formula
  desc "CNES static code analysis tool"
  homepage "https:github.comcnescatlabi-CodeCNES"
  url "https:github.comcnescatlabi-CodeCNESreleasesdownload5.1.0icode-5.1.0.zip"
  sha256 "fc62a12a4e237ad57d23357bfee94ab0f12ed43f0a8400e25a8b298101929966"
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