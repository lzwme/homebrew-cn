class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-13.9.0/flyway-commandline-13.9.0.tar.gz"
  sha256 "023ce936999dab675a995de6cd082e875983c52440a74b4440fa44ca56d50620"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43ed86f89d85fee448a306b847dc1fc7f487263d18f83310f8277b3ab1089115"
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