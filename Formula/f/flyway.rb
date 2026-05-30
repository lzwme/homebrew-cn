class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-12.7.0/flyway-commandline-12.7.0.tar.gz"
  sha256 "b4274f9434c7af702ec1c9513ee0ad4ce0f07c957e163bcdba10c8ac2f0d4822"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74de6123dfc8c9848ffcb4160840031dc33ce026e4818c68428e5b4829690ded"
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