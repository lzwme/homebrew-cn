class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-13.2.0/flyway-commandline-13.2.0.tar.gz"
  sha256 "b8464266d1b86334c17043ef1bd4fd61b00b6d09cd7d4e0715e4ba300683da43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d7fc2e99a6d0a3110f4ec0618a78606ce0feef702b8c3f82cdfdf3a5dd20dd8"
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