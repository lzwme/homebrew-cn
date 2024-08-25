class SpringLoaded < Formula
  desc "Java agent to enable class reloading in a running JVM"
  homepage "https:github.comspring-projectsspring-loaded"
  url "https:search.maven.orgremotecontent?filepath=orgspringframeworkspringloaded1.2.6.RELEASEspringloaded-1.2.6.RELEASE.jar"
  version "1.2.6"
  sha256 "6edd6ffb3fd82c3eee95f5588465f1ab3a94fc5fff65b6e3a262f6de5323d203"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "56e262bc88aebe0ac04e149b8ae57d346e60d2c04e4306a53ba57b69947acb01"
  end

  depends_on "openjdk" => :test

  def install
    (share"java").install "springloaded-#{version}.RELEASE.jar" => "springloaded.jar"
  end

  test do
    system "#{Formula["openjdk"].bin}java", "-javaagent:#{share}javaspringloaded.jar", "-version"
  end
end