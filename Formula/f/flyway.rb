class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-13.6.0/flyway-commandline-13.6.0.tar.gz"
  sha256 "f86cee530264f5516eb82c7cfca571604907c6be7f574a49914307460100fa2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c9c08f529a6963dc8bc1950ab0fb6bca05312de02ee05b844f6ceadc8ed56827"
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