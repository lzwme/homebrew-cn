class Arx < Formula
  desc "Data Anonymization Tool"
  homepage "https://arx.deidentifier.org"
  url "https://ghfast.top/https://github.com/arx-deidentifier/arx/releases/download/v3.9.2/arx-3.9.2-osx-64.jar"
  version "3.9.2"
  sha256 "08d9adb0770725fd1c6eb40cf59979e42992cdeda0cb2cd762e253678fb9db65"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.jar") do |file|
      bin.write_jar_script file, "arx", "-XstartOnFirstThread"
    end
  end
end