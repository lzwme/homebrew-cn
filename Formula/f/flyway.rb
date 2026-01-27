class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.20.3/flyway-commandline-11.20.3.tar.gz"
  sha256 "50051b916a87ab766f7aa3190a6bb2b036940c619ee4ff51071812a616d7a1aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41e6a29bd011c29ef319caef61748d012b48abc1c7009dc368a9044af695e1ed"
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