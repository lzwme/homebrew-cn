class Arx < Formula
  desc "Data Anonymization Tool"
  homepage "https://arx.deidentifier.org"
  url "https://ghfast.top/https://github.com/arx-deidentifier/arx/releases/download/v3.9.1/arx-3.9.1-osx-64.jar"
  version "3.9.1"
  sha256 "d410f22b9146335f510ec3e084c4cc70a695c78e0571cbb41b27896e88c0ed55"

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