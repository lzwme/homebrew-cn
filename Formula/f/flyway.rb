class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-13.12.0/flyway-commandline-13.12.0.tar.gz"
  sha256 "f64b1e5fa3a3433d2f2e874cd9e884b84bb07264f121e2885a76b363ad5ee3e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d952d1b5f2bd907dee80db6c51d685c92925020aeb353deaca5c4a3b76e8b84"
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