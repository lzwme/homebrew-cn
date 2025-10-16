class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.14.1/flyway-commandline-11.14.1.tar.gz"
  sha256 "356c6deea3a200d93ce3b7076ecf75ea335a665519ca7465ad53f7db5324a8eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d3aea858c93905a1a53b9d3acba4dc05bc6d588ccd62a04e04c8d83a168dcb5"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flyway --version")

    assert_match "Successfully validated 0 migrations",
      shell_output("#{bin}/flyway -url=jdbc:h2:mem:flywaydb validate")
  end
end