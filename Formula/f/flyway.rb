class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-12.2.0/flyway-commandline-12.2.0.tar.gz"
  sha256 "f8535d83c28bfe1962fc13482783f924f7460d6d585145e2196a00978742e147"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc7f224e7e035177d6e4f1fd1d89f18e3d358333182c56ad791db33eb07209b5"
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