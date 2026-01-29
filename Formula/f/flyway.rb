class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-12.0.0/flyway-commandline-12.0.0.tar.gz"
  sha256 "68101ba4d2fec09f97392ee0f007fde220b29494c4ec39a56d5895c40ff25753"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "809846605164e6a9f766d0ee5d004826850efd0b96fb5e752d9783155fab6ffc"
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