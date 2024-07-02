class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/10.15.2/flyway-commandline-10.15.2.tar.gz"
  sha256 "8da2dfdd5989da2f38beaaf1e80c19ab8000f69c034ad6c5e267d13d80d9f2b4"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2fda2aebf40c3cb2790245702c2bc68331ca2de78956d2b75baf6c429fb0aca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2fda2aebf40c3cb2790245702c2bc68331ca2de78956d2b75baf6c429fb0aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2fda2aebf40c3cb2790245702c2bc68331ca2de78956d2b75baf6c429fb0aca"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2fda2aebf40c3cb2790245702c2bc68331ca2de78956d2b75baf6c429fb0aca"
    sha256 cellar: :any_skip_relocation, ventura:        "f2fda2aebf40c3cb2790245702c2bc68331ca2de78956d2b75baf6c429fb0aca"
    sha256 cellar: :any_skip_relocation, monterey:       "f2fda2aebf40c3cb2790245702c2bc68331ca2de78956d2b75baf6c429fb0aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe5c0582f9e4260adbeebfa3fc1aff0ee6037b132e191b444fcabbb62972488a"
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