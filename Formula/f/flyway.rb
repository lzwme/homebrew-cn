class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/9.22.1/flyway-commandline-9.22.1.tar.gz"
  sha256 "4c4da2b65f1e2d0f7e44ab5b2710f8155c9a77d0a1b4a3bb8fe6cf7c56f78b96"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b2e6e544e3c54c1b548f5a1f8b8f274dca29d6dc76944d83b3ecdf59947164c"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end