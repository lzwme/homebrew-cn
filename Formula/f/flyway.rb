class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.16.0/flyway-commandline-11.16.0.tar.gz"
  sha256 "e50431fb9ea6d724fd6961c00e4bf7f88d7e859ab342fd469d355c38b888c024"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b5cfc1fcfb88372cf3342f6f32b704c8362a24d8ccc75ccdade38663f1d87ede"
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