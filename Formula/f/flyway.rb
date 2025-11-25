class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.17.2/flyway-commandline-11.17.2.tar.gz"
  sha256 "a8de5af145a37aa4f2cd7cfe510591ed9f93ffcd17b9d7499f8def5b90cb4fa3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc2f0564abb8121eb3f217a96456df4ef007b9d0ea71426d145cd1fe2b71f2e7"
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