class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.11.2/flyway-commandline-11.11.2.tar.gz"
  sha256 "54c8a2331a58884e41b8ed3e22396d60d304321c1931540bb48d630740bb8213"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7924e5e63d2084fc2c8e8a89eba5dad46db26a54d750413452d9681498a23952"
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