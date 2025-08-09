class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.11.0/flyway-commandline-11.11.0.tar.gz"
  sha256 "208449423b022409e6af6fff75a309d2422760949b89d1f3e7f60a4590fcbf43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71d2025dcb332afedd3c6d2f564f50b66c405ab453bed9e4a9a331fabbc964f3"
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