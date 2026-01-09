class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.20.1/flyway-commandline-11.20.1.tar.gz"
  sha256 "077ef2648d8b2177e8b382c817135a5d75b561a2df843dc196b1010c4b49baf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a2b9eabe86c2247c1bd04018b704b86c57b6e26b9eb4bdf811ac1db60b802b7"
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