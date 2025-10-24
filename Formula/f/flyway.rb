class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.15.0/flyway-commandline-11.15.0.tar.gz"
  sha256 "6c22e083508e698ff0496c31d77fbcf829c29f7bc8c1f5d8e3604a3721adac7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e21d96c3c053dbd08910a98d758184f18be29a61bd0444fab88eed38fcc17ee"
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