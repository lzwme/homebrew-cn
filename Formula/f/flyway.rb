class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.19.0/flyway-commandline-11.19.0.tar.gz"
  sha256 "f46ef671f8694deb4cd02fa4fe00332c9efaf211f67e99fcf882424e44ae381f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac6d92b0170f93a3aeecc898f73c21a4d5ddf346e4c2f1672dd1bfd84d4124b2"
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