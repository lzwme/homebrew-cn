class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/10.17.0/flyway-commandline-10.17.0.tar.gz"
  sha256 "caefd51fdb73e033baf005ea6206c7d7bbd58074470ca7b296ea403564bc30e2"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61223771c5ef32980f7a08ae65e4d1f876c144a78261038b11536fe99f333966"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61223771c5ef32980f7a08ae65e4d1f876c144a78261038b11536fe99f333966"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61223771c5ef32980f7a08ae65e4d1f876c144a78261038b11536fe99f333966"
    sha256 cellar: :any_skip_relocation, sonoma:         "44184c6a8125675535b54b16ce7060ce948615cb29c63ff531a4356817396b21"
    sha256 cellar: :any_skip_relocation, ventura:        "44184c6a8125675535b54b16ce7060ce948615cb29c63ff531a4356817396b21"
    sha256 cellar: :any_skip_relocation, monterey:       "61223771c5ef32980f7a08ae65e4d1f876c144a78261038b11536fe99f333966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b528bd4029fc6c24a5e4d1b3f7d7f1296a190e5dd8f3470d3068c1cceb4e2eea"
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