class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/10.13.0/flyway-commandline-10.13.0.tar.gz"
  sha256 "2bef234e974061349cacd33ac1f57be595266f9ed9167392680e7b21134ffe24"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "818b7c5136d42e8d0df96dde552b8ea5abdc5cb407307cc5350cb873db65eb40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38c07fb31927c3f91757e3972a2b77b75e67de5b9e1144ceb8b82e19ad4d88b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "212231b9843df56bbe3a650a88d571c9cf05a123ab83b55c5df887745e487e04"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fa7e41b4b9718133c63f2a6a79991b7a6af9e8e109006e5bc8a0af2c4d69107"
    sha256 cellar: :any_skip_relocation, ventura:        "32aad334501eca0d261dfa3bc053d085ae791d053739b526142dccae64655dba"
    sha256 cellar: :any_skip_relocation, monterey:       "15cb2584d238b00aef55e13e4d8b0137c04cdcdcbb0c2c22026dac537f78505d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142e2c63c66c216b94dec52e0d4e06548e79be7a805481d153f12a9516193790"
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