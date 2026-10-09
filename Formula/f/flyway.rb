class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-13.10.0/flyway-commandline-13.10.0.tar.gz"
  sha256 "4ba7995fb74cf3967d215cc792348ff2dbd61736af93a6fa8a5a2ae7bcb948b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3bc080d458c4a11dd40b9a8527e88ef1b13ed9db68faf13ac0e264e7fa7c2d2a"
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