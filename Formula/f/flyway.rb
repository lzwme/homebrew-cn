class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://ghfast.top/https://github.com/flyway/flyway/releases/download/flyway-11.10.2/flyway-commandline-11.10.2.tar.gz"
  sha256 "d51fc28303d5dbaeaf0b8f8b3bc1d964d36b7d60d98d79b51eda557200c3c410"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "52de5a7137594ef79bac3bcb5cd079c9ee23dc57310df290c9433f2bb9b63b66"
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