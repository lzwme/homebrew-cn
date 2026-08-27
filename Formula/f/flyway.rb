class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-13.4.0/flyway-commandline-13.4.0.tar.gz"
  sha256 "c85afb584341db1108e4a3181fa6b22d7e1340a7beb046f74ab9b357447a382f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f12e8c89cf5a0fb8791079bd1c557fd4e4eeec8193df49d5b7a7120b9d2ad1b"
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