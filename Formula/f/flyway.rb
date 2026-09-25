class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-13.8.0/flyway-commandline-13.8.0.tar.gz"
  sha256 "f773e5369c3e9c040e117835bc6f0cc310733195b58ab605f03acb3a415bbfa8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab11cdaa07ebada8cb03cddafdb27238f42a3c7e0ad5d0be88d1d60fbd43a070"
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