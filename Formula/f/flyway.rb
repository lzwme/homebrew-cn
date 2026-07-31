class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-13.1.0/flyway-commandline-13.1.0.tar.gz"
  sha256 "e4384c95376b8450573867a4aeff1d5bec6b3793768a9a27563331b960a6f070"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c901fa2f0ca26ce0146d53b7baccd51f86210f7a19859c76b103153b2fe23fd0"
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