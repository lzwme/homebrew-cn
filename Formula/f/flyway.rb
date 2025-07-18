class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.10.3/flyway-commandline-11.10.3.tar.gz"
  sha256 "b4fc825a41afbaba4ee2aa56fa7a0e4b9e415442a76ff3e1cbaec28cb9d9efef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4380e623b176a6ed26d31e177b50bfc0a3b5b546a28dce209c63ed1257f9014"
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