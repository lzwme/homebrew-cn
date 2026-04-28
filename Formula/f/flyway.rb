class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-12.5.0/flyway-commandline-12.5.0.tar.gz"
  sha256 "0564155f657802f80461b4d61cfbf8aed80213441eb96c0686466527718b7a4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "82b5e3f03e111736dee47e8d50fab3837a2371065ab68627c1424653f6231f24"
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