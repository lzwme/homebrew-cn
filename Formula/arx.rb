class Arx < Formula
  desc "Data Anonymization Tool"
  homepage "https:arx.deidentifier.org"
  url "https:github.comarx-deidentifierarxreleasesdownloadv3.9.1arx-3.9.1-osx-64.jar"
  version "3.9.1"
  sha256 "d410f22b9146335f510ec3e084c4cc70a695c78e0571cbb41b27896e88c0ed55"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}*.jar") do |file|
      bin.write_jar_script file, "arx", "-XstartOnFirstThread"
    end
  end
end