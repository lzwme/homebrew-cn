class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-13.8.1/flyway-commandline-13.8.1.tar.gz"
  sha256 "5a3f053a5fa8cb75abcfb5d80f649a1a03fb910f6cf77bcc2dfbc477339c3ad3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1cb31603690775978a411d9ed5af7aa25fbb939684b98fd96048274d55728568"
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