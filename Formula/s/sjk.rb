class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https:github.comaragozinjvm-tools"
  url "https:search.maven.orgremotecontent?filepath=orggridkitjvmtoolsjk-plus0.22sjk-plus-0.22.jar"
  sha256 "ab9cf748e76e504d9b11147dfacc9a6b4c18d0a64be721d414de80c281612a29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ac4202db26376047a911b521591a4b3ce22460148c06fce568113ac6ba8f30e"
  end

  depends_on "openjdk"

  def install
    libexec.install "sjk-plus-#{version}.jar"
    bin.write_jar_script libexec"sjk-plus-#{version}.jar", "sjk"
  end

  test do
    system bin"sjk", "jps"
  end
end