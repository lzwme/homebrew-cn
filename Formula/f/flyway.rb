class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.14.0/flyway-commandline-11.14.0.tar.gz"
  sha256 "2e19faf4e621351afb8f077c460297f1fd3e4e923bb8f8af1df4cdb09caffcc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ffe0612f0d49ef221a45d293b6c5812a113c25c95db4ec6a21e5552718ac16e8"
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