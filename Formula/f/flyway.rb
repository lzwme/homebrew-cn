class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/10.18.0/flyway-commandline-10.18.0.tar.gz"
  sha256 "e4b82c5f65cf1e0ef10f4f18dc54bdf8ab2917847badb76a28f923476b90b250"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e76914d870fe7cfb8dc25ddec86dff331c78278ac0eccfee487712564b6857d1"
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