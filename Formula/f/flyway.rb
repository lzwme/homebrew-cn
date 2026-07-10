class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-12.11.0/flyway-commandline-12.11.0.tar.gz"
  sha256 "d88552bb3aedc2ab2faa98fb2a50906e50fb8fb1c22b71cc3acd6d91c2f40a55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab0fc1678fa095a0d118e61d983ab5e349208d46969a4a80d0c526fd067e6bce"
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