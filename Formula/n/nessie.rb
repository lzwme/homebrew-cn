class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://ghfast.top/https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.104.4.tar.gz"
  sha256 "786bea127df4fc116b96116d8178be753aaf31b3b8139bd0d589d9c0534f16b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db8cb991067f70abe21f0e8820cc573ede6ccfb16a924caa458108892fbd3e90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfc7deaf7c2e43d951d4e271682a76e5a69037a1e06552ed73e37b921bf24f67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a73fd51db7a0103148e8f14e68004ef9c199540916ebd7e21cca8fb181c8017"
    sha256 cellar: :any_skip_relocation, sonoma:        "966e0334bb36b67bce39d372e4a0b01840535917a7064392fc951b6ddaa9ad36"
    sha256 cellar: :any_skip_relocation, ventura:       "1f99a5984ae1c5168922c8e2f43227da8ad2a0659805de02732cb4778c98f2ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fbb1d16759a229e84c35d7a447c2658716ac9141d5d91f7e5ba2a460a710440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f33089eba02b13174d6e6337c29e103cbd7384d7b03a94798a32eb3c600361d0"
  end

  depends_on "gradle@8" => :build
  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", ":nessie-quarkus:assemble"
    libexec.install Dir["servers/quarkus-server/build/quarkus-app/*"]
    bin.write_jar_script libexec/"quarkus-run.jar", "nessie"
  end

  service do
    run [opt_bin/"nessie"]
    keep_alive true
    error_log_path var/"log/nessie.log"
    log_path var/"log/nessie.log"
  end

  test do
    port = free_port
    ENV["QUARKUS_HTTP_PORT"] = free_port.to_s
    ENV["QUARKUS_MANAGEMENT_PORT"] = port.to_s
    spawn bin/"nessie"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  end
end