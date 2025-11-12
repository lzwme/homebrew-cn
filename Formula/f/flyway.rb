class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.17.0/flyway-commandline-11.17.0.tar.gz"
  sha256 "29ba5be9c1a87fb0f547d8c14acb5be8fd15bd5a42c50381019a329b30704aa1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9fee7a5f35021dddfbbe8fb5feb387bc24960c547ff4f06ee74f098bc2ee75df"
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