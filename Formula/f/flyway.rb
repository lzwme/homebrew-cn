class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/11.0.1/flyway-commandline-11.0.1.tar.gz"
  sha256 "eddca80d4c7688958488f343510897b6f987383dd4a2596f10b0f6dc9e528ede"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c0532b13d3c2b9d6c7a535d691668ee08b6cc0ebf9984b1ea25a18c295816fe"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end